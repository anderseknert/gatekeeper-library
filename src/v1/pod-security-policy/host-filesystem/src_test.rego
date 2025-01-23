package k8spsphostfilesystem

import rego.v1

test_input_hostpath_block_all if {
	inp := {"review": input_review, "parameters": input_parameters_empty}
	results := violation with input as inp
	count(results) == 1
}

test_input_hostpath_block_all_null_params if {
	inp := {"review": input_review, "parameters": null}
	results := violation with input as inp
	count(results) == 1
}

test_input_hostpath_block_all_no_params if {
	inp := {"review": input_review}
	results := violation with input as inp
	count(results) == 1
}

test_input_hostpath_many_block_all if {
	inp := {"review": input_review_many, "parameters": input_parameters_empty}
	results := violation with input as inp
	count(results) == 2
}

test_input_hostpath_no_volumes if {
	inp := {"review": input_review_no_volumes, "parameters": input_parameters_in_list}
	results := violation with input as inp
	count(results) == 0
}

test_input_hostpath_mixed_volumes if {
	inp := {"review": input_review_many_mixed_volumes, "parameters": input_parameters_in_list}
	results := violation with input as inp
	count(results) == 0
}

test_input_hostpath_mixed_volumes_not_allowed if {
	inp := {"review": input_review_many_mixed_volumes, "parameters": input_parameters_not_in_list}
	results := violation with input as inp
	count(results) == 1
}

test_input_hostpath_no_hostpath if {
	inp := {"review": input_review_many_no_hostpath, "parameters": input_parameters_in_list}
	results := violation with input as inp
	count(results) == 0
}

test_input_hostpath_allowed_readonly if {
	inp := {"review": input_review_many, "parameters": input_parameters_in_list}
	results := violation with input as inp
	count(results) == 0
}

test_input_hostpath_not_allowed_readonly if {
	inp := {"review": input_review, "parameters": input_parameters_not_in_list}
	results := violation with input as inp
	count(results) == 1
}

test_input_hostpath_many_not_allowed_readonly if {
	inp := {"review": input_review_many, "parameters": input_parameters_not_in_list}
	results := violation with input as inp
	count(results) == 2
}

test_input_hostpath_allowed_writable_allowed if {
	inp := {"review": input_review_writable, "parameters": input_parameters_in_list_writable}
	results := violation with input as inp
	count(results) == 0
}

test_input_hostpath_allowed_writable_not_allowed if {
	inp := {"review": input_review_writable, "parameters": input_parameters_in_list}
	results := violation with input as inp
	count(results) == 1
}

test_input_hostpath_not_allowed_writable if {
	inp := {"review": input_review_writable, "parameters": input_parameters_not_in_list}
	results := violation with input as inp
	count(results) == 1
}

test_input_hostpath_allowed_not_writable if {
	inp := {"review": input_review, "parameters": input_parameters_in_list}
	results := violation with input as inp
	count(results) == 1
}

test_input_hostpath_allowed_is_writable if {
	inp := {"review": input_review, "parameters": input_parameters_in_list_writable}
	results := violation with input as inp
	count(results) == 0
}

test_input_hostpath_not_allowed_is_writable if {
	inp := {"review": input_review, "parameters": input_parameters_not_in_list_writable}
	results := violation with input as inp
	count(results) == 1
}

test_input_hostpath_not_allowed if {
	inp := {"review": input_review, "parameters": input_parameters_not_in_list_writable}
	results := violation with input as inp
	count(results) == 1
}

test_input_hostpath_allowed_readonly_mixed_parameters if {
	inp := {"review": input_review_many_mixed_writable, "parameters": input_parameters_in_list}
	results := violation with input as inp
	count(results) == 1
}

test_input_hostpath_allowed_readonly_mixed__writable_parameters if {
	inp := {"review": input_review_many_readonly, "parameters": input_parameters_in_list_mixed_writable}
	results := violation with input as inp
	count(results) == 0
}

test_input_hostpath_allowed_mixed_writable_mixed_parameters if {
	inp := {"review": input_review_many_mixed_writable, "parameters": input_parameters_in_list_mixed_writable}
	results := violation with input as inp
	count(results) == 0
}

test_update if {
	inp := {"review": object.union(input_review, {"operation": "UPDATE"}), "parameters": input_parameters_empty}
	results := violation with input as inp
	count(results) == 0
}

# Init Containers
test_input_hostpath_allowed_readonly_init_containers if {
	inp := {"review": input_init_review, "parameters": input_parameters_in_list}
	results := violation with input as inp
	count(results) == 1
}

test_input_hostpath_allowed_readonly_many_init_containers if {
	inp := {"review": input_init_review_many, "parameters": input_parameters_in_list}
	results := violation with input as inp
	count(results) == 0
}

test_input_hostpath_not_allowed_readonly_init_containers if {
	inp := {"review": input_init_review, "parameters": input_parameters_not_in_list}
	results := violation with input as inp
	count(results) == 1
}

test_input_hostpath_many_not_allowed_readonly_init_containers if {
	inp := {"review": input_init_review_many, "parameters": input_parameters_not_in_list}
	results := violation with input as inp
	count(results) == 2
}

# Unit Tests
test_path_matches if {
	path_matches("/foo", "/foo/")
	path_matches("/foo", "/foo/r")
	path_matches("/", "/foo")
	not path_matches("/foo", "/fool")
	not path_matches("/foo", "/etc/foo")
	not path_matches("/foo", "/")
}

input_review := {"object": {
	"metadata": {"name": "nginx"},
	"spec": {
		"containers": input_containers_one,
		"volumes": input_volumes,
	},
}}

input_init_review := {"object": {
	"metadata": {"name": "nginx"},
	"spec": {
		"initContainers": input_containers_one,
		"volumes": input_volumes,
	},
}}

input_review_writable := {"object": {
	"metadata": {"name": "nginx"},
	"spec": {
		"containers": input_containers_writable,
		"volumes": input_volumes,
	},
}}

input_review_many := {"object": {
	"metadata": {"name": "nginx"},
	"spec": {
		"containers": input_containers_many,
		"volumes": input_volumes_many,
	},
}}

input_review_many_readonly := {"object": {
	"metadata": {"name": "nginx"},
	"spec": {
		"containers": input_containers_many,
		"volumes": input_volumes_many_mixed,
	},
}}

input_review_many_mixed_writable := {"object": {
	"metadata": {"name": "nginx"},
	"spec": {
		"containers": input_containers_many_mixed_writable,
		"volumes": input_volumes_many_mixed,
	},
}}

input_init_review_many := {"object": {
	"metadata": {"name": "nginx"},
	"spec": {
		"initContainers": input_containers_many,
		"volumes": input_volumes_many,
	},
}}

input_review_no_volumes := {"object": {
	"metadata": {"name": "nginx"},
	"spec": {"containers": [{
		"name": "nginx",
		"image": "nginx",
	}]},
}}

input_review_many_mixed_volumes := {"object": {
	"metadata": {"name": "nginx"},
	"spec": {
		"containers": input_containers_many_mixed_volume,
		"volumes": input_volumes,
	},
}}

input_review_many_no_hostpath := {"object": {
	"metadata": {"name": "nginx"},
	"spec": {
		"initContainers": input_containers_many,
		"volumes": input_volumes_no_hostpath,
	},
}}

input_containers_one := [{
	"name": "nginx",
	"image": "nginx",
	"volumeMounts": [{
		"mountPath": "/cache",
		"name": "cache-volume",
	}],
}]

input_containers_writable := [{
	"name": "nginx",
	"image": "nginx",
	"volumeMounts": [{
		"mountPath": "/cache",
		"name": "cache-volume",
		"readOnly": false,
	}],
}]

input_containers_many := [
	{
		"name": "nginx",
		"image": "nginx",
		"volumeMounts": [{
			"mountPath": "/cache",
			"name": "cache-volume",
			"readOnly": true,
		}],
	},
	{
		"name": "nginx2",
		"image": "nginx",
		"volumeMounts": [{
			"mountPath": "/cache",
			"name": "cache-volume2",
			"readOnly": true,
		}],
	},
]

input_containers_many_mixed_volume := [
	{
		"name": "nginx",
		"image": "nginx",
		"volumeMounts": [{
			"mountPath": "/cache",
			"name": "cache-volume",
			"readOnly": true,
		}],
	},
	{
		"name": "nginx2",
		"image": "nginx",
	},
]

input_containers_many_mixed_writable := [
	{
		"name": "nginx",
		"image": "nginx",
		"volumeMounts": [{
			"mountPath": "/cache",
			"name": "cache-volume",
			"readOnly": true,
		}],
	},
	{
		"name": "nginx2",
		"image": "nginx",
		"volumeMounts": [{
			"mountPath": "/cache",
			"name": "cache-volume2",
			"readOnly": false,
		}],
	},
]

input_volumes := [{
	"name": "cache-volume",
	"hostPath": {"path": "/tmp"},
}]

input_volumes_no_hostpath := [
	{
		"name": "cache-volume",
		"emptyDir": {},
	},
	{
		"name": "cache-volume2",
		"secret": {"secretName": "test-secret"},
	},
]

input_volumes_many := [
	{
		"name": "cache-volume",
		"hostPath": {"path": "/tmp"},
	},
	{
		"name": "cache-volume2",
		"hostPath": {"path": "/tmp/test"},
	},
]

input_volumes_many_mixed := [
	{
		"name": "cache-volume",
		"hostPath": {"path": "/tmp"},
	},
	{
		"name": "cache-volume2",
		"hostPath": {"path": "/foo/test"},
	},
]

input_parameters_empty := {"allowedHostPaths": []}

input_parameters_in_list := {"allowedHostPaths": [{
	"readOnly": true,
	"pathPrefix": "/tmp",
}]}

input_parameters_not_in_list := {"allowedHostPaths": [{
	"readOnly": true,
	"pathPrefix": "/foo",
}]}

input_parameters_in_list_writable := {"allowedHostPaths": [
	{"pathPrefix": "/tmp"},
	{"pathPrefix": "/foo"},
]}

input_parameters_not_in_list_writable := {"allowedHostPaths": [{"pathPrefix": "/foo"}]}

input_parameters_in_list_mixed_writable := {"allowedHostPaths": [
	{
		"pathPrefix": "/tmp",
		"readOnly": true,
	},
	{"pathPrefix": "/foo"},
]}
