watch curl -s https://multi-cloud.kcdc.rhlabs.io https://multi-cloud.dev.kcdc.rhlabs.io  \
  $(. /srv/login.sh && for i in 1 2 3; do echo -n "http://hello-multi-cloud.apps.${clusters[$i]} "; done)
