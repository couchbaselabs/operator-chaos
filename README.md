# Couchbase Operator Chaos Testing


## Considerations & Requirements
Longevity testing
* Operator robustness - crash up operator pods
* Operator resilience - crash up server pods
* Server work during this - self certification?
* Operator work? Upgrade, scaling, etc.? (Nice to have)
* How to monitor it/verify? CMOS?

Requirements:
* Pod killing
* Network errors
* Resource throttling
* Simple integration with KIND (plus OCP+GKE - nice to have)
* CNCF
* Declarative and automated
* Extensible to custom actions? (Nice to have)
* Can use outside k8s for server? (Nice to have)

## Connect Talk
- Review of options
- We chose X for arbitrary reason Y
- What we did?
- The issues up we found
- What we're going to do?
- Git repo dedicated for this

### Set up slides in Google Docs:
* 2 minutes intro of us - Both
* 3 minutes intro to chaos testing - Roo
* 5 minutes of what we need/what we looked for - Pat
* 5 minutes discussing pros/cons of each, and selection of what we took further - Pat
* 5 minutes of what we did - Roo
* 5 minutes of future work to do - Roo
* 5 minutes Q&A - Both
