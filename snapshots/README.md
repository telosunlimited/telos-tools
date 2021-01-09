# Snapshot service for telos mainnet

## This contains an small sciprt to take snapshots and compress/move to a webroot folder served by NGINX

### First we weconfigure nginx to filter the /v1/producer path unless it comes from localhost

nginx vhost file for the api proxy

```
    location ^~ /v1/producer {
        allow 127.0.0.1;
        deny all;
    }
```

### We create the vhost to serve the snapshots

```
server {
    root /var/www/snapshots/;
    server_name snapshots.telosunlimited.io;
    fancyindex on;              # Enable fancy indexes.
    fancyindex_exact_size off;  # Output human-readable file sizes.
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/snapshots.telosunlimited.io/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/snapshots.telosunlimited.io/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
}
```

### Then we need to enable the producer_api_plugin (do not leave this open, i'm filtering all API requests with Patroneosd and nginx in front, only allowed from localhost)

On nodeos config.ini:
```
plugin = eosio::producer_api_plugin
```

### Finally we configure the right paths on the shell sciprt and add it to the crontab file if we want to schedule it.
