<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Http\Controllers\ActivityController;
// use Illuminate\Support\Facades\A;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    
    public function login()
    {
        
        if (Auth::check()) {
            return redirect('/home');
        }
        
        return view('auth.login');
    }


    public function auth(Request $request)
    {
        $credentials = $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        if (Auth::attempt($credentials)) {
            $request->session()->regenerate();
            
            return redirect()->intended('/home');
        }

        return back()->withErrors([
            'email' => 'Email atau password salah.',
        ]);
    }


    public function registration()
    {

        if (Auth::check()) {
            return redirect('/home');
        }
        
        return view('auth.registration');
    }

    public function register(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:6',
        ]);

        User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
        ]);

        return redirect('/registration')->with('success', 'Registrasi berhasil');
    }


    public function home()
    {
        
        if (!Auth::check()) {
            return redirect('/login');
        }
        
        $user = Auth::user();
        
        $activities = ActivityController::filter();
        // dd($activities);
        // $user->activities = $activities;
        return view('auth.home', compact('user', 'activities'));
    }

    public function logout()
    {
        Auth::logout();
        
        request()->session()->invalidate();
        request()->session()->regenerateToken();
        
        return redirect('/login');
    }
}