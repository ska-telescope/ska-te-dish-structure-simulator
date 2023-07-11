echo "ds-sim IP: $(dig ds-sim.$KUBE_NAMESPACE.svc.$KUBE_HOST @$KUBE_DNS +short)"
