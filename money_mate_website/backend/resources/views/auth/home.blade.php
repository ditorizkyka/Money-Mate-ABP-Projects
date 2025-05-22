<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Activities Table</title>
  <style>
    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
    }
    th, td {
      border: 1px solid #ccc;
      padding: 8px;
      text-align: left;
    }
    th {
      background-color: #f4f4f4;
    }
  </style>
</head>
<body>

<div class="container">
  <div class="home-container">
    <h1>Home Page</h1>
    <div class="welcome-message">
      <p>Selamat datang, <strong>{{ $user->name }}</strong>!</p>
      <p>Anda berhasil login dengan email: {{ $user->email }}</p>
    </div>
    <div class="logout-btn">
      <a href="{{ route('logout') }}" class="btn btn-danger">Logout</a>
    </div>
  </div>
</div>

<h2>Activities Table - User ID {{ $user->userID }}</h2>
<table>
  <thead>
    <tr>
      <th>userID</th>
      <th>activitiesName</th>
      <th>activitiesType</th>
      <th>activitiesSpent</th>
      <th>date</th>
      <th>deskripsi</th>
      <th>priority</th>
      <th>created_at</th>
      <th>updated_at</th>
    </tr>
  </thead>
  <tbody>
  @forelse($activities as $activity)
    <tr>
      <td>{{ $activity['userID'] }}</td>
      <td>{{ $activity['activitiesName'] }}</td>
      <td>{{ $activity['activitiesType'] }}</td>
      <td>{{ $activity['activitiesSpent'] }}</td>
      <td>{{ $activity['date'] }}</td>
      <td>{{ $activity['deskripsi'] }}</td>
      <td>{{ $activity['priority'] }}</td>
      <td>{{ $activity['created_at'] }}</td>
      <td>{{ $activity['updated_at'] }}</td>
    </tr>
  @empty
    <tr>
      <td colspan="9" style="text-align:center;">Tidak ada aktivitas ditemukan.</td>
    </tr>
  @endforelse
</tbody>
</table>

</body>
</html>
