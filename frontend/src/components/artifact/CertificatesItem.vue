<script setup lang="ts">
import { type PropType } from "vue"

import type { CertificateType } from "@/schemas"

defineProps({
  certificates: {
    type: Array as PropType<CertificateType[]>,
    required: true
  }
})
</script>

<template>
  <div
    class="field is-grouped is-grouped-multiline"
    v-for="(certificate, index) in certificates"
    :key="index"
  >
    <div class="control">
      <div class="tags has-addons are-medium">
        <span class="tag is-dark">Domains</span>
        <span class="tag">{{ certificate.domains }}</span>
      </div>
    </div>
    <div class="control" v-if="certificate.fingerprint_sha1.length">
      <div class="tags has-addons are-medium">
        <span class="tag is-dark">SHA1 Fingerprint</span>
        <span class="tag">{{ certificate.fingerprint_sha1 }}</span>
      </div>
    </div>
    <div class="control">
      <div class="tags has-addons are-medium">
        <span class="tag is-dark">IP</span>
        <span class="tag">{{ certificate.ip || "N/A" }}</span>
      </div>
    </div>
    <div class="control">
      <div class="tags has-addons are-medium">
        <span class="tag is-dark">Is expired</span>
        <span class="tag">{{ certificate.is_expired }}</span>
      </div>
    </div>
    <div class="control" v-if="certificate.issuer_common_name.length">
      <div class="tags has-addons are-medium">
        <span class="tag is-dark">Issuer name</span>
        <span class="tag">{{ certificate.issuer_common_name }}</span>
      </div>
    </div>
    <div class="control" v-if="certificate.issuer_organization.length">
      <div class="tags has-addons are-medium">
        <span class="tag is-dark">Issuer organization</span>
        <span class="tag">{{ certificate.issuer_organization }}</span>
      </div>
    </div>
    <div class="control">
      <div class="tags has-addons are-medium">
        <span class="tag is-dark">Not before</span>
        <span class="tag">{{ certificate.not_before || "N/A" }}</span>
      </div>
    </div>
    <div class="control">
      <div class="tags has-addons are-medium">
        <span class="tag is-dark">Not after</span>
        <span class="tag">{{ certificate.not_after || "N/A" }}</span>
      </div>
    </div>
    <div class="control">
      <div class="tags has-addons are-medium">
        <span class="tag is-dark">Updated on</span>
        <span class="tag">{{ certificate.createdAt }}</span>
      </div>
    </div>
  </div>
</template>
