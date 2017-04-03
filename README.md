
### USAGE ###

```
docker build -t onedrive .
docker run --rm \
  -u $(id -u $USER):$(id -g $USER) \
  -e HOME=/tmp \
  -v /path/to/download:/download \
  onedrive '$URL'
```

After `docker run` is finished files from the onedrive shared folder
are available in `/path/to/download`.

HINT: Use single quote around the 1drv URL since it usually contains `!`
which is by default interpreted by `bash`.

