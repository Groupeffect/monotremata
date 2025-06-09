#!/bin/sh
MLB_RANGE=192.168.100.20-192.168.100.99
cmd_mk8s_addons(){
    echo "MK8S Addons"
    microk8s enable metallb:$MLB_RANGE
    microk8s enable argocd
    microk8s enable registry
}

cmd_k8s_patch_addons(){
    echo "MK8S Patch Addons"
}

cmd_check_container(){
    kubectl get svc/argo-cd-argocd-server -n argocd
}

cmd_argocd_get_admin_pw(){

    kubectl exec svc/argo-cd-argocd-server argocd -n argocd -- argocd admin initial-password
}

cmd_argocd_change_to_loadbalancer(){
    kubectl patch service argo-cd-argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
    kubectl patch service argo-cd-argocd-server -n argocd -p '{"annotations": "metallb.universe.tf/address-pool: default-addresspool"}'
}