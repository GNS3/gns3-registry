#!/usr/bin/env python3
#
# netem-conf - configure NETem parameter
#
import copy
import os
import subprocess
import json
from dialog import Dialog

# minimal config
config = { 'eth0_to_eth1': {}, 'symmetric': True }

# open dialog system
d = Dialog(dialog="dialog", autowidgetsize=True)
d.add_persistent_args(["--no-collapse"])


# configure NETem parameter in linux
def conf_netem(link, dev):
    # remove current config
    subprocess.call(['sudo', '-S', 'tc', 'qdisc', 'del', 'dev', dev, 'root'],
                    stdin=subprocess.DEVNULL, stdout=subprocess.DEVNULL,
                    stderr=subprocess.DEVNULL)

    # base NETem command line
    netem_cmd = ['sudo', '-S', 'tc', 'qdisc', 'add', 'dev', dev]

    # configure bandwidth with htb
    if config[link].get('bandwidth') is not None:
        buffer = max(int(0.3*config[link]['bandwidth']+0.5), 1600)
        bw_cmd =  ['sudo', '-S', 'tc', 'qdisc', 'add', 'dev', dev,
                   'root', 'handle', '1:',
                   'tbf', 'rate', str(config[link]['bandwidth'])+"kbit",
                   'buffer', str(buffer), 'latency', '20ms']
        proc = subprocess.Popen(bw_cmd, stdin=subprocess.DEVNULL,
                          stdout=subprocess.DEVNULL, stderr=subprocess.PIPE)
        out, err = proc.communicate()
        if err:
            err = err.decode('ascii').strip()
            if err == "Password:":
                err = "sudo needs password"
            d.msgbox("Can't configure bandwidth !!!\n\n" + \
                     " ".join(bw_cmd) + "\n\n" + str(err))
            return False
        netem_cmd += ['parent', '1:1', 'handle', '10']
    else:
        netem_cmd += ['root', 'handle', '1']

    netem_cmd.append('netem')

    # add delay to command line
    if config[link].get('delay') is not None:
        netem_cmd.append("delay")
        netem_cmd.append(str(config[link]['delay']) + "ms")
        if config[link].get('jitter') is not None:
            netem_cmd.append(str(config[link]['jitter']) + "ms")

    # add loss to command line
    # see http://netgroup.uniroma2.it/TR/TR-loss-netem.pdf
    if config[link].get('loss') is not None:
        if config[link].get('loss_burst') is None:
            p13 = config[link]['loss']
            p31 = 100 - config[link]['loss']
        else:
            p13 = config[link]['loss'] / \
                  (config[link]['loss_burst'] * (1 - config[link]['loss'] / 100))
            p31 = 100 / config[link]['loss_burst']
        netem_cmd.append("loss")
        netem_cmd.append("gemodel")
        netem_cmd.append(str(p13) + "%")
        netem_cmd.append(str(p31) + "%")
        netem_cmd.append("0")
        netem_cmd.append("0")

    # configure NETem parameter
    proc = subprocess.Popen(netem_cmd, stdin=subprocess.DEVNULL,
                            stdout=subprocess.DEVNULL, stderr=subprocess.PIPE)
    out, err = proc.communicate()
    if err:
        err = err.decode('ascii').strip()
        if err == "Password:":
            err = "sudo needs password"
        d.msgbox("Can't configure NETem !!!\n\n" + \
                 " ".join(netem_cmd) + "\n\n" + str(err))
        return False

    return True


# bandwidth configuration of a link
def string_bandwidth(link):
    if config[link].get('bandwidth') is None:
        bw_text = "<No Limit>"
    else:
        bw_text = str(config[link]['bandwidth']) + " kBit/s"
    return bw_text


# delay configuration of a link
def string_delay(link):
    if config[link].get('delay') is None:
        delay_text = "<None>"
    else:
        delay_text = str(config[link]['delay']) + " ms"
        if config[link].get('jitter') is not None:
            delay_text += ",  Jitter:  " + str(config[link]['jitter']) + " ms"
    return delay_text


# loss configuration of a link
def string_loss(link):
    if config[link].get('loss') is None:
        loss_text = "<None>"
    else:
        loss_text = str(config[link]['loss']) + " %"
        if config[link].get('loss_burst') is not None:
            loss_text += ",  Burst:  " + str(config[link]['loss_burst'])
    return loss_text


# convert string to number
def conv_num(string):
    string = string.strip()
    if string == "":
        x = None
    else:
        try:
            x = float(string)
            if abs(x) < 1e9 and x == int(x):
                x = int(x)
        except ValueError:
            raise ValueError("Invalid number: " + string)
    return x


# convert string to postitive number (or zero)
def conv_num_positive(string):
    x = conv_num(string)
    if x is not None and x < 0:
        raise ValueError("Negative number: " + string)
    return x


# convert string to number greater or equal one
def conv_num_ge_one(string):
    x = conv_num(string)
    if x is not None and x < 1:
        raise ValueError("Must be at least 1: " + string)
    return x


# convert string to percentage
def conv_num_percent(string):
    x = conv_num(string)
    if x is not None and (x < 0 or x > 100):
        raise ValueError("Percentage must be 0..100: " + string)
    return x


# link parameter for parsing
# ( variable, label, unit, conversion_function, input_width )
link_param_bandwidth = [
    ( "bandwidth",  "Bandwidth",   "kBit/s", conv_num_positive, 10 ) ]
link_param_delay = [
    ( "delay",      "Delay",       "ms",     conv_num_positive, 10 ),
    ( "jitter",     "Jitter",      "ms",     conv_num_positive, 10 ) ]
link_param_loss = [
    ( "loss",       "Packet Loss", "%",      conv_num_percent,  10 ),
    ( "loss_burst", "Loss Burst",  "Pkts",   conv_num_ge_one,   10 ) ]
link_param_all = link_param_bandwidth + link_param_delay + link_param_loss


# get link configuration
def get_link(link, link_params):
    global config
    title = link.replace('_to_', ' -> ')

    # convert link parameter to strings
    fields = []
    for param in link_params:
        val = config[link].get(param[0])
        if val is None:
            val = ""
        else:
            val = str(val)
        fields.append(val)

    # get parameter, until no errors left
    ok = False
    while not ok:
        # create elements array for dialog.form
        elements = []
        i = 0
        for param in link_params:
            label = param[1]
            if param[2] is not None:
                label += " [" + param[2] + "]"
            elements.append((label, i+1, 2, fields[i], i+1, 22, param[4], 0))
            i += 1

        # get parameter
        code, fields = d.form("Link configuration " + title, elements,
                              title=" "+title+" ")
        if code != Dialog.OK:
            break

        # convert string fields to data
        data = {}
        ok = True
        i = 0
        for param in link_params:
            try:
                data[param[0]] = param[3](fields[i])
            except ValueError as err:
                ok = False
                d.msgbox("Input error !!!\n\n" + param[1] + ":\n" + str(err))
                break
            i += 1
        # additinal checks
        if ok and data.get('delay') is not None and \
           data.get('jitter') is not None and \
           data['jitter'] > data['delay']:
            ok = False
            d.msgbox("Input error !!!\n\nJitter must be less than delay.")
        # all fine, handle some special values and copy data to link config
        if ok:
            if data.get('delay') == 0:
                data['delay'] = None
            if data.get('delay') is None or data.get('jitter') == 0:
                data['jitter'] = None
            if data.get('loss') == 0:
                data['loss'] = None
            if data.get('loss') is None or data.get('loss_burst') == 1:
                data['loss_burst'] = None
            for param in data:
                config[link][param] = data[param]
    return


# menu functions
def menu_0to1():
    get_link('eth0_to_eth1', link_param_all)


def menu_0to1_bandwidth():
    get_link('eth0_to_eth1', link_param_bandwidth)


def menu_0to1_delay():
    get_link('eth0_to_eth1', link_param_delay)


def menu_0to1_loss():
    get_link('eth0_to_eth1', link_param_loss)


def menu_asymmetric():
    global config
    code = d.yesno("Do you want to change to symmetric mode?")
    if code == Dialog.OK:
        config['symmetric'] = True
        del config['eth1_to_eth0']


def menu_symmetric():
    global config
    code = d.yesno("Do you want to change to asymmetric mode?")
    if code == Dialog.OK:
        config['symmetric'] = False
        config['eth1_to_eth0'] = copy.deepcopy(config['eth0_to_eth1'])


def menu_1to0():
    if config['symmetric']:
        menu_symmetric()
    else:
        get_link('eth1_to_eth0', link_param_all)


def menu_1to0_bandwidth():
    get_link('eth1_to_eth0', link_param_bandwidth)


def menu_1to0_delay():
    get_link('eth1_to_eth0', link_param_delay)


def menu_1to0_loss():
    get_link('eth1_to_eth0', link_param_loss)


def menu_load():
    global config
    title = " Load Configuration "
    code, path = d.fselect("configs/", 10, 60, title=title)
    if code == Dialog.OK:
        try:
            with open(path, "r") as f:
                config = json.load(f)
        except (ValueError, IOError, OSError) as err:
            d.msgbox("Error !!!\n\n" + str(err), title=title)


def menu_save():
    title = " Save Configuration "
    code, path = d.fselect("configs/", 10, 60, title=title)
    if code == Dialog.OK:
        try:
            with open(path, "w") as f:
                json.dump(config, f, sort_keys=True, indent=4,
                          separators=(',', ': '))
                f.write("\n")
        except (ValueError, IOError, OSError) as err:
            d.msgbox("Error !!!\n\n" + str(err), title=title)

    # backup to persistent disk
    subprocess.call(['filetool.sh', '-b'],
                    stdin=subprocess.DEVNULL, stdout=subprocess.DEVNULL,
                    stderr=subprocess.DEVNULL)


def menu_shell():
    d.clear()
    print('Starting sub-shell, return with "exit"...')
    subprocess.call('/bin/sh')


def menu_shutdown():
    d.clear()
    subprocess.call(['sudo', 'poweroff'])


menu_functions = {
    'eth0->eth1':    menu_0to1,
    '  Bandwidth':   menu_0to1_bandwidth,
    '  Delay':       menu_0to1_delay,
    '  Loss':        menu_0to1_loss,
    'eth1->eth0':    menu_1to0,
    '  Asymmetric':  menu_asymmetric,
    '  Symmetric':   menu_symmetric,
    '  Bandwidth ':  menu_1to0_bandwidth,
    '  Delay ':      menu_1to0_delay,
    '  Loss ':       menu_1to0_loss,
    'Load':          menu_load,
    'Save':          menu_save,
    'Shell':         menu_shell,
    'Shutdown':      menu_shutdown
}


# Main starts here
try:
    # create config subdirectory
    os.makedirs("configs", exist_ok=True)
    # try to load initial configuration
    try:
        with open("configs/init", "r") as f:
            config = json.load(f)
    except (ValueError, IOError, OSError):
        pass

    # input loop
    while True:
        # set parameter in linux
        if conf_netem('eth0_to_eth1', 'eth1'):
            if config['symmetric']:
                conf_netem('eth0_to_eth1', 'eth0')
            else:
                conf_netem('eth1_to_eth0', 'eth0')

        # main menue
        choices = [ ('eth0->eth1',  "Configure link eth0 -> eth1"),
                    ('  Bandwidth', string_bandwidth('eth0_to_eth1')),
                    ('  Delay',     string_delay('eth0_to_eth1')),
                    ('  Loss',      string_loss('eth0_to_eth1')),
                    ('eth1->eth0',  "Configure link eth1 -> eth0") ]
        if config['symmetric']:
            choices += [ ('  Symmetric', "Same config as eth0 -> eth1") ]
        else:
            choices += [ ('  Asymmetric', "Use specific configuration"),
                         ('  Bandwidth ', string_bandwidth('eth1_to_eth0')),
                         ('  Delay ',     string_delay('eth1_to_eth0')),
                         ('  Loss ',      string_loss('eth1_to_eth0')) ]
        choices += [ ("Load",     "Load configuration from file"),
                     ("Save",     "Save configuration to file"),
                     ("Shell",    "Open a console"),
                     ("Shutdown", "Shutdown the VM") ]
        code, tag = d.menu("NETem Configuration", choices=choices,
                           title=" NETem Configuration ", no_cancel=True)
        if code == Dialog.OK and tag in menu_functions:
            menu_functions[tag]()

# intercept Ctrl-C
except KeyboardInterrupt:
    d.clear()
    exit(0)
