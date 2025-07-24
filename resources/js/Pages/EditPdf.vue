<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue'
import { Head } from '@inertiajs/vue3'
import { ref, watch, nextTick } from 'vue'
import * as pdfjsLib from 'pdfjs-dist'
import pdfjsWorker from 'pdfjs-dist/legacy/build/pdf.worker.mjs?url'

// Set up the worker manually using Blob
pdfjsLib.GlobalWorkerOptions.workerSrc = pdfjsWorker;

const canvasRef = ref(null)
const pdfUrl = ref(null);
const currentPage = ref(1);
const totalPages = ref(1);
const scale = ref(1.3);
let pdfDoc = null; // Store the loaded PDF document
let renderTask = null;

const thumbnails = ref([]);

async function generateThumbnails(pdf) {
  thumbnails.value = [];
  for (let i = 1; i <= pdf.numPages; i++) {
    const page = await pdf.getPage(i);
    const viewport = page.getViewport({ scale: 0.2 });
    // Create an offscreen canvas
    const canvas = document.createElement('canvas');
    canvas.width = viewport.width;
    canvas.height = viewport.height;
    await page.render({ canvasContext: canvas.getContext('2d'), viewport }).promise;
    thumbnails.value.push(canvas.toDataURL());
  }
}

const handleFileChange = async (event) => {
  const file = event.target.files[0]
  if (file && file.type === 'application/pdf') {
    pdfUrl.value = URL.createObjectURL(file);
  }

  const fileReader = new FileReader()
  fileReader.onload = async function () {
    const typedarray = new Uint8Array(this.result)

    pdfDoc = await pdfjsLib.getDocument(typedarray).promise;
    totalPages.value = pdfDoc.numPages;
    await generateThumbnails(pdfDoc);
    await renderPage(currentPage.value);
  }

  fileReader.readAsArrayBuffer(file)
}

async function renderPage(pageNum) {
  if (!pdfDoc) return;
  const page = await pdfDoc.getPage(pageNum);
  const viewport = page.getViewport({ scale: scale.value });
  const canvas = canvasRef.value;
  const context = canvas.getContext('2d');
  canvas.width = viewport.width;
  canvas.height = viewport.height;
  await page.render({ canvasContext: context, viewport }).promise;
}

function goToPage(index) {
  currentPage.value = index + 1;
}

function zoomIn() {
  scale.value = Math.min(scale.value + 0.1, 3); // Max 300%
}

function zoomOut() {
  scale.value = Math.max(scale.value - 0.1, 0.5); // Min 50%
}

watch(currentPage, async (newPage) => {
  if (pdfDoc && newPage >= 1 && newPage <= totalPages.value) {
    await nextTick();
    await renderPage(newPage);
  }
});

watch(scale, async () => {
  await nextTick();
  await renderPage(currentPage.value);
});

watch(pdfUrl, async (newUrl) => {
  if (newUrl) {
    currentPage.value = 1;
  }
});
</script>

<template>
  <Head title="Edit PDF" />
  <AuthenticatedLayout>
    <template v-if="!pdfUrl" #header>
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
    <div v-if="!pdfUrl" class="flex flex-col items-center mt-8">
      <div class="relative flex flex-col items-center">
        <!-- Main Button -->
        <label class="bg-red-500 text-white text-2xl font-semibold px-16 py-8 rounded-2xl cursor-pointer shadow-lg flex items-center justify-center w-[400px] max-w-sm md:max-w-md lg:max-w-lg text-center">
          Select PDF file
          <input type="file" accept="application/pdf" class="hidden" @change="handleFileChange" />
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
      <span class="mt-4 text-gray-500 text-lg">or drop PDF here</span>
    </div>
    <div v-else class="flex flex-row w-full min-h-screen h-screen" style="height: calc(100vh - 64px);">
      <!-- Left: Thumbnails -->
      <div class="w-1/5 h-full p-4 border-r overflow-y-auto shadow-lg flex flex-col">
        <div
          v-for="(thumb, idx) in thumbnails"
          :key="idx"
          class="mb-4 flex flex-col items-center justify-center rounded-lg py-4"
          style="min-height: 180px;"
          @click="goToPage(idx)"
        >
          <img :src="thumb" :alt="'Page ' + (idx + 1)" class="border rounded mx-auto" />
          <div class="text-center text-xs mt-2">Page {{ idx + 1 }}</div>
        </div>
      </div>
      <!-- Center: Main PDF Canvas -->
      <div class="w-3/5 h-full flex flex-col items-center justify-center p-4">
        <div class="relative overflow-auto w-full h-full flex justify-center items-start mt-6">
          <canvas ref="canvasRef" class="shadow-lg border rounded-xl mt-7"></canvas>
          <!-- Floating Zoom Buttons at Bottom Center -->
          <div class="absolute left-1/2 -translate-x-1/2 z-10 flex items-center space-x-2 bg-gray-200/90 rounded-full shadow px-4 py-2" style="bottom: 120px;">
            <button @click="zoomOut" class="px-3 py-1 bg-gray-200 hover:bg-gray-300 rounded-full text-xl font-bold">-</button>
            <span class="mx-2 font-semibold text-gray-700">{{ (scale * 100).toFixed(0) }}%</span>
            <button @click="zoomIn" class="px-3 py-1 bg-gray-200 hover:bg-gray-300 rounded-full text-xl font-bold">+</button>
          </div>
        </div>
        <!-- Navigation buttons, if desired -->
      </div>
      <!-- Right: Options -->
      <div class="w-1/5 h-full p-4 border-l flex flex-col items-center">
        <!-- Save button and other options go here -->
      </div>
    </div>
  </AuthenticatedLayout>
</template>