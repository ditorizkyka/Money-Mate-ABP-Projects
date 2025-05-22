<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Database\Eloquent\Relations\HasMany;

class User extends Authenticatable
{
    protected $primaryKey = 'userID';

    protected $fillable = [
        'email',
        'name',
        'password',
        'limit',
        'totalSpent',
    ];

    public function activities(): HasMany
    {
        return $this->hasMany(Activity::class, 'userID', 'userID');
    }
}
