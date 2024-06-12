<script setup lang="ts">
import { type PropType } from "vue"

import type { CertificateType } from "@/schemas"

defineProps({
  certificates: {
    type: Array as PropType<CertificateType[]>,
    required: true
  }
})

const getQuery = (domains: string) => {
  return `domains:"${domains}"`
}
</script>

<template>
  <div class="tags are-medium">
    <router-link
      class="tag"
      v-for="certificate in certificates"
      :key="certificate.domains"
      :to="{ name: 'Artifacts', query: { q: getQuery(certificate.domains) } }"
      >{{ certificate.domains }}</router-link
    >
  </div>
</template>
