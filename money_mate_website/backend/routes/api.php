<?php

use Illuminate\Auth\Middleware\Authenticate;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware(Authenticate::using('sanctum'));

Route::apiResource('/activities', App\Http\Controllers\Api\ActivityController::class);
Route::apiResource('/user', App\Http\Controllers\Api\UserController::class);

//users - menggunakan firebase_uid sebagai parameter
Route::get('/user', [App\Http\Controllers\Api\UserController::class, 'index']);
Route::post('/user', [App\Http\Controllers\Api\UserController::class, 'store']);
Route::get('/user/{firebase_uid}', [App\Http\Controllers\Api\UserController::class, 'show']);
Route::put('/user/{firebase_uid}', [App\Http\Controllers\Api\UserController::class, 'update']);
Route::patch('/user/{firebase_uid}', [App\Http\Controllers\Api\UserController::class, 'update']);
Route::delete('/user/{firebase_uid}', [App\Http\Controllers\Api\UserController::class, 'destroy']);

// Route tambahan untuk verifikasi
Route::get('/user/{firebase_uid}/verify', [App\Http\Controllers\Api\UserController::class, 'verifyUpdate']);

