<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;


class User extends Authenticatable
{
    use HasFactory, Notifiable;
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'firebase_uid', // Firebase UID for user identification
        'name',
        'email',
        'limit', // Example: spending limit
        'created_at',
        'updated_at',
        // jika  ada
    ];

    /**
     * The attributes that should be cast.
     * The attributes that should be cast.
     *
     * @var array<string, string>
     * @var array<string, string>
     */
    protected $casts = [
        'limit' => 'decimal:2',
        'total_spent' => 'decimal:2',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];
}
