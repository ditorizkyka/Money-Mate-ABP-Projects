<?php

use App\Http\Controllers\ActivityController;

Route::get('/activities', [ActivityController::class, 'filter']);
Route::get('/activities/{id}', [ActivityController::class, 'show']);
Route::post('/activities', [ActivityController::class, 'store']);
Route::put('/activities/{id}', [ActivityController::class, 'update']);
Route::delete('/activities/{id}', [ActivityController::class, 'destroy']);

