watch curl -s $(. /srv/login.sh && for i in 1 2 3; do echo -n "http://hello-multi-cloud.apps.${clusters[$i]} "; done)
