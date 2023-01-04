# Packer for Debian based GNS3 appliances

## Packer Version Dependency

Packer versions 1.6.0 or later do not accept templates
that use the `iso_checksum_type` attribute.
To use these newer versions, you must delete the line
containing `iso_checksum_type` from debian.json.


## Debian CLI installation

```
packer build debian.json
```
