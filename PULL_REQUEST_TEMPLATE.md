Before submitting a pull request, please check the following.

---
When updating an **existing** appliance:
- [ ] The new version is on top.
- [ ] The filenames in the "images" section are unique, to avoid appliances / version overwriting each other.
- [ ] If you forked the repo, running check.py doesn't drop any errors for the updated file.
---
When creating a **new** appliance:
- It's tested locally, i.e.
  - [ ] You dragged an instance into a project on your box, got it installed (if necessary), and did some basic network checks (ping, UI reachable, etc.).
  - [ ] GNS3 VM can run it without any tweaks.
  - [ ] The device is in the right category: router, switch, guest (hosts), firewall
  - [ ] You filled in as much info as possible (checks the schemas and other appliance files for some guidance).
- [ ] When adding a container: it builds on Docker Hub and can be pulled.
- [ ] The filenames in the "images" section are unique (to avoid appliances and/or versions overwriting each other).
- [ ] If you forked the repo, running check.py doesn't drop any errors for the new file.
- [ ] *Optional: a symbol has been created for the new appliance.*
