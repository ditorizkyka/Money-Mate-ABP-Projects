<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
       Schema::create('activities', function (Blueprint $table) {
        $table->id();
        $table->string('firebase_uid'); // Firebase UID for user identification
        $table->string('name');
        $table->string('description')->nullable();
        $table->string('type'); // e.g., 'general', 'event', 'task'
        $table->string('priority');
        $table->integer('spent')->default(0);
        $table->date('date')->nullable();
        $table->timestamps();
    });

    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('activities');
    }
};
