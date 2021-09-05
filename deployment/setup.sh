for clusterId in 1 2 3; do
  oc-login $clusterId
  secret=$(oc get secret gitlab-registry-auth -n multi-cloud 2>/dev/null | grep gitlab-registry-auth)
  echo ">>$secret<<"
  if [ "$secret" != '' ]; then
    oc replace -f secrets.yaml 
  else
    oc create -f secrets.yaml 
  fi
  oc secrets link default gitlab-repo-auth     --for=pull -n multi-cloud
  oc secrets link default gitlab-registry-auth --for=pull -n multi-cloud
done
oc-login 1

