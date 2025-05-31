<?php

use Illuminate\Auth\Middleware\Authenticate;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

//posts
Route::apiResource('/activities', App\Http\Controllers\Api\ActivityController::class);
Route::apiResource('/user', App\Http\Controllers\Api\UserController::class);
