
### USAGE ###

```
docker build -t onedrive .
docker run --rm -v /path/to/download:/download onedrive '$URL'
sudo chown -R $USER /path/to/download
```

After `docker run` is finished files from the onedrive shared folder
are available in `/path/to/download`.

HINT: Use single quote around the 1drv URL since it usually contains `!`
which is by default interpreted by `bash`.

### TODO ###

* get rid of `including Capybara::DSL in the global scope is not recommended!`
* take care of permissions/ownership of extracted files (currently it's `root`)
