<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head } from '@inertiajs/vue3';
</script>

<template>
  <Head title="Edit PDF" />
  <AuthenticatedLayout>
    <template #header>
        <div class="flex flex-col items-center">
            <h1
                class="text-5xl font-semibold leading-tight text-gray-800 text-center"
            >
                PDF Editor
            </h1>
            <h2
                class="text-xl font-sans leading-tight text-gray-800 text-center max-w-2xl"
            >
              Edit PDF by adding text, shapes, comments and highlights. Your secure and simple tool to edit PDF.
            </h2>
        </div>
    </template>
    <div class="flex flex-col items-center mt-8">
      <div class="relative flex flex-col items-center">
        <!-- Main Button -->
        <label class="bg-red-500 text-white text-2xl font-semibold px-16 py-8 rounded-2xl cursor-pointer shadow-lg flex items-center justify-center w-[400px] max-w-sm md:max-w-md lg:max-w-lg text-center">
          Select PDF file
          <input type="file" accept="application/pdf" class="hidden" />
        </label>
        <!-- Floating Icons -->
        <div class="absolute right-[-70px] top-1/2 transform -translate-y-1/2 flex flex-col space-y-4">
          <button class="bg-red-500 rounded-full p-3 shadow-lg flex items-center justify-center">
            <span class="material-icons text-white text-3xl">cloud</span>
          </button>
          <button class="bg-red-500 rounded-full p-3 shadow-lg flex items-center justify-center">
            <span class="material-icons text-white text-3xl">cloud_upload</span>
          </button>
        </div>
      </div>
      <!-- Drop text -->
      <span class="mt-4 text-gray-500 text-lg">or drop PDF here</span>
    </div>
  </AuthenticatedLayout>
</template>