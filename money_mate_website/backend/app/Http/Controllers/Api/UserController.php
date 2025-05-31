<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Http\Resources\UserResource;
use App\Models\User;
use Illuminate\Support\Facades\Validator;

class UserController extends Controller
{
    public function index()
    {
        $users = User::latest()->paginate(5);
        return new UserResource(true, 'List Data User', $users);
    }

    public function show($firebase_uid)
    {
        $user = User::where('firebase_uid', $firebase_uid)->first();

        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'User tidak ditemukan',
            ], 404);
        }

        return response()->json([
            'success' => true,
            'message' => 'Detail Data User',
            'data' => $user
        ]);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'firebase_uid' => 'required|string|max:255|unique:users,firebase_uid',
            'name'        => 'required|string|max:255',
            'email'       => 'nullable|string|email',
            'limit'       => 'required|numeric|min:0',
            'total_spent' => 'required|numeric|min:0',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation Error',
                'errors' => $validator->errors()
            ], 422);
        }

        $user = User::create([
            'firebase_uid' => $request->firebase_uid,
            'name'        => $request->name,
            'email'       => $request->email,
            'limit'       => $request->limit,
            'total_spent' => $request->total_spent,
        ]);

        return new UserResource(true, 'Data User Berhasil Ditambahkan!', $user);
    }

    public function update(Request $request, $firebase_uid)
    {

        //define validation rules
        $validator = Validator::make($request->all(), [
            'firebase_uid' => 'nullable|string|max:255|unique:users,firebase_uid,',
            'name'        => 'nullable|string|max:255',
            'email'       => 'nullable|string|email',
            'limit'       => 'nullable|numeric|min:0',
            'total_spent' => 'nullable|numeric|min:0',
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }
        //find user by id
        $user = User::where('firebase_uid', $firebase_uid)->first();
        

       //pengecekan jika limit ada/ nama ada/ limit tidak ada

        if ($request->has('limit')) {
             $user->update([
            'limit'     => $request->limit,
        ]);
        }

        if ($request->has('name')) {
             $user->update([
            'name'     => $request->name,
        ]);
        }


        //return response
        return new UserResource(true, 'Data Post Berhasil Diubah!', $user);
    }

    public function destroy($firebase_uid)
    {
         $user = User::where('firebase_uid', $firebase_uid)->first();
        
        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'User tidak ditemukan',
            ], 404);
        }

        $user->delete();

        return response()->json([
            'success' => true,
            'message' => 'Data User Berhasil Dihapus!',
        ]);
    }

    // Method tambahan untuk verifikasi data
    public function verifyUpdate($firebase_uid)
    {
        $user = User::where('firebase_uid', $firebase_uid)->first();
        
        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'User tidak ditemukan',
            ], 404);
        }

        // Ambil data langsung dari database tanpa cache
        $freshUser = User::where('firebase_uid', $firebase_uid)->first();

        return response()->json([
            'success' => true,
            'message' => 'Data fresh dari database',
            'data' => $freshUser,
            'timestamp' => now()
        ]);
    }
}