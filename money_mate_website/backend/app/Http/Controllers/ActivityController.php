<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Activity;

class ActivityController extends Controller
{
    // GET /api/activities — ambil semua data
    public function index()
    {
        return response()->json(Activity::all(), 200);
    }

    // GET /api/activities/{id} — ambil satu data
    public function show($id)
    {
        $activity = Activity::find($id);
        if (!$activity) {
            return response()->json(['message' => 'Activity not found.'], 404);
        }

        return response()->json($activity, 200);
    }

    // POST /api/activities — buat data baru
    public function store(Request $request)
    {
        $validated = $request->validate([
            'userID' => 'required|exists:users,userID',
            'activitiesName' => 'required|string|max:255',
            'activitiesType' => 'required|string|max:255',
            'activitiesSpent' => 'required|numeric',
            'date' => 'required|date',
            'deskripsi' => 'nullable|string',
            'priority' => 'nullable|string|max:20',
        ]);

        $activity = Activity::create($validated);

        return response()->json([
            'message' => 'Activity successfully created.',
            'data' => $activity
        ], 201);
    }

    // PUT /api/activities/{id} — update data
    public function update(Request $request, $id)
    {
        $activity = Activity::find($id);
        if (!$activity) {
            return response()->json(['message' => 'Activity not found.'], 404);
        }

        $validated = $request->validate([
            'userID' => 'sometimes|exists:users,userID',
            'activitiesName' => 'sometimes|string|max:255',
            'activitiesType' => 'sometimes|string|max:255',
            'activitiesSpent' => 'sometimes|numeric',
            'date' => 'sometimes|date',
            'deskripsi' => 'nullable|string',
            'priority' => 'nullable|string|max:20',
        ]);

        $activity->update($validated);

        return response()->json([
            'message' => 'Activity successfully updated.',
            'data' => $activity
        ]);
    }

    // DELETE /api/activities/{id} — hapus data
    public function destroy($id)
    {
        $activity = Activity::find($id);
        if (!$activity) {
            return response()->json(['message' => 'Activity not found.'], 404);
        }

        $activity->delete();

        return response()->json(['message' => 'Activity successfully deleted.']);
    }
}
