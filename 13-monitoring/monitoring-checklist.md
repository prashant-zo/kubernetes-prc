# Kubernetes Monitoring Checklist

## Metrics to Always Alert On
- [ ] Pod restart rate > threshold (CrashLoopBackOff early warning)
- [ ] Deployment available replicas == 0 (app is down)
- [ ] Node CPU > 85% sustained (need scaling)
- [ ] Node Memory > 90% (risk of OOMKill)
- [ ] PVC usage > 85% (disk will fill)
- [ ] HPA at maxReplicas (can't scale further)
- [ ] Certificate expiry < 30 days

## Golden Signals (Site Reliability Engineering)
- Latency    — how long requests take (P50, P95, P99)
- Traffic    — how many requests per second
- Errors     — error rate (4xx, 5xx)
- Saturation — how full is the system (CPU, memory, queue depth)

## Log Best Practices
- Structured JSON logs (easier to query in Loki/ELK)
- Include: timestamp, level, traceID, service, message
- Never log passwords, tokens, PII
- Use log levels: DEBUG (dev) / INFO (prod) / WARN / ERROR

## Dashboard Must-Haves
- Cluster overview (nodes, pods, deployments health)
- Per-namespace resource usage vs quota
- Per-deployment: replicas, restarts, CPU, memory
- Ingress: request rate, error rate, latency
- PVC usage trends
