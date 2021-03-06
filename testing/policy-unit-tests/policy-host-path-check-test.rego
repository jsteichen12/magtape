package kubernetes.admission.test_policy_host_path

import data.kubernetes.admission.policy_host_path

test_host_path_allowed {
    in := {
        "apiVersion": "admission.k8s.io/v1beta1",
        "kind": "AdmissionReview",
        "request": {
            "dryRun": false,
            "kind": {
                "group": "",
                "kind": "Pod",
                "version": "v1"
            },
            "namespace": "test1",
            "object": {
                "apiVersion": "v1",
                "kind": "Pod",
                "metadata": {
                "annotations": {
                    "kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"v1\",\"kind\":\"Pod\",\"metadata\":{\"annotations\":{},\"labels\":{\"run\":\"toolbox\"},\"name\":\"toolbox\",\"namespace\":\"test1\"},\"spec\":{\"containers\":[{\"command\":[\"sleep\",\"360000\"],\"image\":\"jmsearcy/twrtools\",\"imagePullPolicy\":\"Always\",\"name\":\"toolbox\",\"ports\":[{\"containerPort\":8080,\"hostPort\":8080}]}],\"volumes\":[{\"hostPath\":{\"path\":\"/data\"},\"name\":\"default-token\"}]}}\n"
                },
                "creationTimestamp": "2020-02-25T19:23:08Z",
                "labels": {
                    "run": "toolbox"
                },
                "name": "toolbox",
                "namespace": "test1",
                "uid": "413e9d97-5804-11ea-b876-005056a7db08"
                },
                "spec": {
                    "containers": [
                        {
                        "command": [
                            "sleep",
                            "360000"
                        ],
                        "image": "jmsearcy/twrtools",
                        "imagePullPolicy": "Always",
                        "name": "toolbox",
                        "resources": {},
                        "terminationMessagePath": "/dev/termination-log",
                        "terminationMessagePolicy": "File",
                        "volumeMounts": [
                            {
                            "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                            "name": "default-token-q999w",
                            "readOnly": true
                            }
                        ]
                        }
                    ],
                    "volumes": [
                        {
                            "name": "default-token-q999w",
                            "secret": {
                                "secretName": "default-token-q999w"
                            }
                        }
                    ]
                },
                "status": {
                "phase": "Pending",
                "qosClass": "BestEffort"
                }
            },
            "oldObject": null,
            "operation": "CREATE",
            "resource": {
                "group": "",
                "resource": "pods",
                "version": "v1"
            },
            "uid": "413ea31f-5804-11ea-b876-005056a7db08",
            "userInfo": {
                "groups": [
                "group1"
                ],
                "username": "user1"
            }
        }
    }

    count(policy_host_path.deny) == 0 with input as in
}

test_host_path_denied {
    in := {
        "apiVersion": "admission.k8s.io/v1beta1",
        "kind": "AdmissionReview",
        "request": {
            "dryRun": false,
            "kind": {
                "group": "",
                "kind": "Pod",
                "version": "v1"
            },
            "namespace": "test1",
            "object": {
                "apiVersion": "v1",
                "kind": "Pod",
                "metadata": {
                "annotations": {
                    "kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"v1\",\"kind\":\"Pod\",\"metadata\":{\"annotations\":{},\"labels\":{\"run\":\"toolbox\"},\"name\":\"toolbox\",\"namespace\":\"test1\"},\"spec\":{\"containers\":[{\"command\":[\"sleep\",\"360000\"],\"image\":\"jmsearcy/twrtools\",\"imagePullPolicy\":\"Always\",\"name\":\"toolbox\",\"ports\":[{\"containerPort\":8080,\"hostPort\":8080}]}],\"volumes\":[{\"hostPath\":{\"path\":\"/data\"},\"name\":\"default-token\"}]}}\n"
                },
                "creationTimestamp": "2020-02-25T19:23:08Z",
                "labels": {
                    "run": "toolbox"
                },
                "name": "toolbox",
                "namespace": "test1",
                "uid": "413e9d97-5804-11ea-b876-005056a7db08"
                },
                "spec": {
                    "containers": [
                        {
                        "command": [
                            "sleep",
                            "360000"
                        ],
                        "image": "jmsearcy/twrtools",
                        "imagePullPolicy": "Always",
                        "name": "toolbox",
                        "resources": {},
                        "terminationMessagePath": "/dev/termination-log",
                        "terminationMessagePolicy": "File",
                        "volumeMounts": [
                            {
                            "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                            "name": "default-token-q999w",
                            "readOnly": true
                            }
                        ]
                        }
                    ],
                    "volumes": [
                        {
                        "hostPath": {
                            "path": "/data",
                            "type": ""
                        },
                        "name": "default-token"
                        },
                        {
                        "name": "default-token-q999w",
                        "secret": {
                            "secretName": "default-token-q999w"
                        }
                        }
                    ]
                },
                "status": {
                "phase": "Pending",
                "qosClass": "BestEffort"
                }
            },
            "oldObject": null,
            "operation": "CREATE",
            "resource": {
                "group": "",
                "resource": "pods",
                "version": "v1"
            },
            "uid": "413ea31f-5804-11ea-b876-005056a7db08",
            "userInfo": {
                "groups": [
                "group1"
                ],
                "username": "user1"
            }
        }
    }

    # count(policy_host_path.deny) == 1 with input as in
    policy_host_path.deny[_] ==  {
            "errcode": "MT1010",
            "msg": "[FAIL] MED - hostPath is configured for volume \"default-token\" (MT1010)",
            "name": "policy-host-path",
            "severity": "MED"
        }
    with input as in
}
