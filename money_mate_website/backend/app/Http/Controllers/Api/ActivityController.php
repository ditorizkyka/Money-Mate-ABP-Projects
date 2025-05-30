<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Carbon\Carbon;
//import model Post
use App\Models\Activity;

//import resource activityResource
use App\Http\Resources\ActivityResource;

//import facade Validator
use Illuminate\Support\Facades\Validator;
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

    /**
     * show
     *
     * @param  mixed $id
     * @return void
     */
    public function show($firebase_uid)
    {
        //find post by ID
        $activity = Activity::where('firebase_uid', $firebase_uid)->get();

        //return single post as a resource
        return new ActivityResource(true, 'Detail Data Activity!', $activity);
    }

    /**
     * update
     *
     * @param  mixed $request
     * @param  mixed $id
     * @return void
     */
    public function update(Request $request, $id)
    {

        //find post by ID
        $activity = Activity::find($id);
        //define validation rules
        $validator = Validator::make($request->all(), [
            'firebase_uid'=> 'nullable|string|max:255', // Firebase UID
            'name'        => 'nullable|string|max:255',
            'description' => 'nullable|string',
            'type'        => 'nullable|string|in:education,travel,item,other',
            'priority'    => 'nullable|string|in:noturgent,urgent',
            'spent'       => 'required|numeric',
            'date'        => 'nullable|date', // tetap validasi tanggal
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }

        $date = $request->date ? Carbon::parse($request->date)->format('Y-m-d H:i:s') : null;


        
        $activity->update([
            'spent'     => $request->spent,
                
        ]);

        // $activity = Activity::update([
        //     'firebase_uid'     => $request->firebase_uid, // Firebase UID
        //     'name'        => $request->name,
        //     'description' => $request->description,
        //     'type'        => $request->type,
        //     'priority'    => $request->priority,
        //     'spent'       => $request->spent,
            
        // ]);

        //return response
        return new ActivityResource(true, 'Data Post Berhasil Diubah!', $activity);
    }

    public function store(Request $request)
{
    $validator = Validator::make($request->all(), [
        'firebase_uid'     => 'required|string|max:255', // Firebase UID
        'name'        => 'required|string|max:255',
        'description' => 'nullable|string',
        'type'        => 'required|string|in:education,travel,item,other',
        'priority'    => 'required|string|in:noturgent,urgent',
        'spent'       => 'required|numeric',
        'date'        => 'nullable|date', // tetap validasi tanggal
    ]);

    if ($validator->fails()) {
        return response()->json($validator->errors(), 422);
    }

    $date = $request->date ? Carbon::parse($request->date)->format('Y-m-d H:i:s') : null;

    $activity = Activity::create([
        'firebase_uid'     => $request->firebase_uid, // Firebase UID
        'name'        => $request->name,
        'description' => $request->description,
        'type'        => $request->type,
        'priority'    => $request->priority,
        'spent'       => $request->spent,
        'date'        => $date,
    ]);

    return response()->json([
        'success' => true,
        'message' => 'Data Activity Berhasil Ditambahkan!',
        'data'    => $activity
    ]);
}

    

}
