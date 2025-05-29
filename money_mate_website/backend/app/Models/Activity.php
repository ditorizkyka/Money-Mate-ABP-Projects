<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Activity extends Model
{
    protected $fillable = [
        'firebase_uid', // Firebase UID for user identification
        'name',
        'description',
        'type',
        'priority',
        'spent',
        'date',
        'start_date',
        'end_date',
        // jika ada
    ];

}
