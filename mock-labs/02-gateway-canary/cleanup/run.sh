#!/usr/bin/env bash
# Mock 02 정리: shop namespace(앱, Gateway, HTTPRoute) 삭제. NGINX Gateway Fabric은 남긴다(다음 setup이 재사용)
set -euo pipefail
kubectl delete namespace shop --ignore-not-found
