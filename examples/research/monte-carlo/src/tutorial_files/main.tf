# Copyright 2024 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

locals {
  # This label allows for billing report tracking based on module.
  bucket = replace(var.gcs_bucket_path, "gs://", "")
}

resource "random_id" "resource_name_suffix" {
  byte_length = 4
}

# settings.toml
resource "google_storage_bucket_object" "settings_obj_toml" {
  name = "settings.toml"
  content = templatefile("${path.module}/settings.tpl.toml", {
    project_id   = var.project_id
    topic_id     = var.topic_id
    topic_schema = var.topic_schema
    bucket_name  = local.bucket
    region       = var.region
  })
  bucket = local.bucket
}

# run_me_first.sh
resource "google_storage_bucket_object" "run_me_first_sh_obj" {
  name = "run_me_first.sh"
  content = templatefile("${path.module}/run_me_first.tpl.sh", {
    cluster_name = var.cluster_name
    project_id   = var.project_id
    bucket_name  = local.bucket
    region       = var.region
  })
  bucket = local.bucket
}

# FSI_MonteCarlo.ipynb
resource "google_storage_bucket_object" "ipynb_obj_fsi" {
  name = "FSI_MonteCarlo.ipynb"
  content = templatefile("${path.module}/FSI_MonteCarlo.ipynb", {
    project_id = var.project_id
    dataset_id = var.dataset_id
    table_id   = var.table_id
  })
  bucket = local.bucket
}

# gke_batch.py
resource "google_storage_bucket_object" "get_gke_batch_py" {
  name    = "gke_batch.py"
  content = file("${path.module}/gke_batch.py")
  bucket  = local.bucket
}

# requirements.txt
resource "google_storage_bucket_object" "get_requirements_txt" {
  name    = "requirements.txt"
  content = file("${path.module}/requirements.txt")
  bucket  = local.bucket
}
