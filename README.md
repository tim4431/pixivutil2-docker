# PixivUtil2-docker
This image is based on Hamuko's [pixivutil2-docker](https://github.com/Hamuko/pixivutil2-docker), with telegram report feature added.

Docker container builds of [PixivUtil2](https://github.com/tim4431/PixivUtil2), which is forked from Nandaka's [PixivUtil2](https://github.com/Nandaka/PixivUtil2/).

## Example usage

```bash
docker run \
    --rm \
    -it \
    -v ~/.local/pixivutil2/db/:/db/ \
    -v ~/.local/pixivutil2/config.ini:/config.ini \
    -v ~/.local/pixivutil2/pixivutil.log:/pixivutil.log \
    -v ~/Downloads/:/downloads/ \
    ghcr.io/hamuko/pixivutil2-docker
```

Make sure that you keep your config.ini updated with the paths you mount your files/directories. In the prior example, the download directory is mounted as `/downloads/` and the database file is mounted as `/db/db.sqlite`, meaning that the PixivUtil2 configuration file should have these values:

```ini
[Settings]
rootDirectory = /downloads/
dbPath = /db/db.sqlite
```

For frequent use, it's recommended to define your `docker run` command as an alias. This allows to easily run PixivUtil2, even with command-line arguments.

```
~ $ alias pixivutil2='docker run --rm -it -v [...] ghcr.io/hamuko/pixivutil2-docker'
~ $ pixivutil2 -x -s 1 9314725
┌──────────────────────────────────────────────────────────┐
│ PixivDownloader2 version 20220701                        │
│ https://github.com/Nandaka/PixivUtil2/releases           │
│ Donate at https://bit.ly/PixivUtilDonation               │
└──────────────────────────────────────────────────────────┘
Reading //config.ini ...
Configuration loaded.
Using custom DB Path: /db/db.sqlite
Creating database... done.
Only process members where the last update is >= 7 days ago
Using Username: xxxxxx
Trying to log in with saved cookie
Login successful.
My User Id: xxxxxx.
Premium User: False.
Processing Member Id: 9314725
```

## Telegram Report Feature
```
pixivutil2 -rp
```