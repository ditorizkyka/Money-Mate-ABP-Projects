<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Activity extends Model
{
    protected $primaryKey = 'activitiesID';
    public $incrementing = true;

    protected $fillable = [
        'userID',
        'activitiesName',
        'activitiesType',
        'activitiesSpent',
        'date',
        'deskripsi',
        'priority',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class, 'userID', 'userID');
    }
}
