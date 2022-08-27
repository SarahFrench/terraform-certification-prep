# Notes

## 1 - Multiple versions of the same provider

This doesn't work:


```
terraform init

Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/google versions matching "4.0.0, 4.33.0"...
- Finding hashicorp/random versions matching "3.3.2"...
- Installing hashicorp/random v3.3.2...
- Installed hashicorp/random v3.3.2 (signed by HashiCorp)
╷
│ Warning: Duplicate required provider
│ 
│   on main.tf line 7, in terraform:
│    7:     goog = {
│    8:       source = "hashicorp/google"
│    9:       version = "4.33.0"
│   10:     }
│ 
│ Provider hashicorp/google with the local name "goog" was previously required as "google". A provider can only be required once within
│ required_providers.
╵

╷
│ Error: Failed to query available provider packages
│ 
│ Could not retrieve the list of available versions for provider hashicorp/google: no available releases match the given constraints 4.0.0,
│ 4.33.0
╵
```

See here - reasoning is that providers cross module boundaries : https://discuss.hashicorp.com/t/multiple-versions-of-same-provider-explicit-module-provider/20832

## 2 - Local names

If the google provider is listed in required_providers and the local name is set as goog but the resources have no provider argument then this warning shows:

```
│ Warning: Duplicate required provider
│ 
│   on main.tf line 24:
│   24: resource "google_storage_bucket" "auto-expire-bucket" {
│ 
│ Provider "registry.terraform.io/hashicorp/google" was implicitly required via resource
│ "google_storage_bucket.auto-expire-bucket", but listed in required_providers as "goog". Either the local name in
│ required_providers must match the resource name, or the "goog" provider must be assigned within the resource block.
```

But it still works as it determines that there is a provider that fulfills the implicit requirement.

Terraform does not download 2 version of google provider. You could imagine a different scenario where TF hadn't picked up on the issue and instead:
- downloaded the `goog` google provider and left it unused
- then downloaded the latest version of google provider because it's implictly required

## 3 - Aliases

Aliases are set using local names

## Extra

If you set `provider = foobar` in a resource then Terraform tries to find a `hashicorp/foobar` provider - its a way you can override Terraform looking for a provider with a name matching the start of the resource type name, but avoid including it in `required_provider`