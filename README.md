Gitlab integration with ACM

Edit secret.yaml
git update-index --assume-unchanged secret.yaml

oc create -f app.yaml -f secret.yaml
