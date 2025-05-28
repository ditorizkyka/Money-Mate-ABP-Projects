<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

//import model Post
use App\Models\Activity;

//import resource activityResource
use App\Http\Resources\ActivityResource;
class ActivityController extends Controller
{
    /**
     * index
     *
     * @return void
     */
    public function index()
    {
        //get all posts
        $activities = Activity::latest()->paginate(5);

        //return collection of posts as a resource
        return new ActivityResource(true, 'List Data Activity', $activities);
    }

    public function store(Request $request)
{
    // Define validation rules
    $validator = Validator::make($request->all(), [
        'name'        => 'required|string|max:255',
        'description' => 'nullable|string',
        'type'        => 'required|string|in:general,event,task',
        'priority'    => 'required|string|in:low,medium,high',
        'spent'       => 'required|numeric', // asumsi disimpan sebagai angka (rupiah)
        'date'        => 'nullable|date',
    ]);

    // Check if validation fails
    if ($validator->fails()) {
        return response()->json($validator->errors(), 422);
    }

    // Create activity
    $activity = Activity::create([
        'name'        => $request->name,
        'description' => $request->description,
        'type'        => $request->type,
        'priority'    => $request->priority,
        'spent'       => $request->spent,
        'date'        => $request->date,
    ]);

    // Return response
    return response()->json([
        'success' => true,
        'message' => 'Data Activity Berhasil Ditambahkan!',
        'data'    => $activity
    ]);
}

}
