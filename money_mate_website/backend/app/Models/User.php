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

    
       /**
     * The attributes that should be hidden for serialization.
     *
     * @var list<string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }
}