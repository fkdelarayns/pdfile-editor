<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head, Link } from '@inertiajs/vue3';
</script>

<template>
    <Head title="Dashboard" />

    <AuthenticatedLayout>
        <template #header>
            <div class="flex flex-col items-center">
                <h1
                    class="text-5xl font-semibold leading-tight text-gray-800 text-center"
                >
                    Every tool you need to work with PDFs in one place.
                </h1>
                <h2
                    class="text-2xl font-semibold leading-tight text-gray-500 text-center"
                >
                    Every tool you need to use PDFs, at your fingertips. All are 100% FREE and easy to use! Merge, split,
                     compress, convert, rotate, unlock and watermark PDFs with just a few clicks.
                </h2>
            </div>
        </template>
        <div class="flex justify-center min-h-screen">
            <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-4 w-full max-w-7xl mx-auto mt-5 h-[200px]">
                <Link href="/edit-pdf" class="bg-white p-5 flex flex-col items-center justify-center h-full transition duration-300 hover:opacity-80 group hover:shadow-lg cursor-pointer">
                    <span class="material-icons text-blue-500 text-4xl mb-2 transition-transform duration-300 group-hover:scale-125">edit</span>
                    <span class="text-xl text-black mb-2 font-sans font-bold">Edit PDF</span>
                    <span class="text-gray-500 text-sm text-center">Add text, images, shapes or freehand annotations to a PDF document.</span>
                </Link>
                <div class="bg-white p-5 flex flex-col items-center justify-center h-full transition duration-300 hover:opacity-80 group hover:shadow-lg cursor-pointer">
                    <span class="material-icons text-indigo-500 text-4xl mb-2 transition-transform duration-300 group-hover:scale-125">draw</span>
                    <span class="text-xl text-black mb-2 font-sans font-bold">Sign PDF</span>
                    <span class="text-gray-500 text-sm text-center">Add your signature or request electronic signatures on PDF documents.</span>
                </div>
                <div class="bg-white p-5 flex flex-col items-center justify-center h-full transition duration-300 hover:opacity-80 group hover:shadow-lg cursor-pointer">
                    <span class="material-icons text-yellow-500 text-4xl mb-2 transition-transform duration-300 group-hover:scale-125">image</span>
                    <span class="text-xl text-black mb-2 font-sans font-bold">JPG to PDF</span>
                    <span class="text-gray-500 text-sm text-center">Convert JPG images into a single PDF file quickly and easily.</span>
                </div>
                <div class="bg-white p-5 flex flex-col items-center justify-center h-full transition duration-300 hover:opacity-80 group hover:shadow-lg cursor-pointer">
                    <span class="material-icons text-green-500 text-4xl mb-2 transition-transform duration-300 group-hover:scale-125">insert_photo</span>
                    <span class="text-xl text-black mb-2 font-sans font-bold">PDF to JPG</span>
                    <span class="text-gray-500 text-sm text-center">Extract pages from a PDF and save them as high-quality JPG images.</span>
                </div>
                <div class="bg-white p-5 flex flex-col items-center justify-center h-full transition duration-300 hover:opacity-80 group hover:shadow-lg cursor-pointer">
                    <span class="material-icons text-red-500 text-4xl mb-2 transition-transform duration-300 group-hover:scale-125">merge_type</span>
                    <span class="text-xl text-black mb-2 font-sans font-bold">Merge PDF</span>
                    <span class="text-gray-500 text-sm text-center">Combine multiple PDF files into a single, organized document with ease.</span>
                </div>
            </div>
        </div>
    </AuthenticatedLayout>
</template>
