using System.Security.Claims;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.FileProviders;
using Backend.Models;

var builder = WebApplication.CreateBuilder(args);

// Connect to the database PostgreSQL using Entity Framework Core
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection")));

// 2. Configure cookie authentication
builder.Services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
    .AddCookie(options =>
    {
        options.Cookie.Name = "AuthCookie";
        options.ExpireTimeSpan = TimeSpan.FromDays(7);
        options.Events.OnRedirectToLogin = context =>
        {
            context.Response.StatusCode = 401;
            return Task.CompletedTask;
        };
    });

builder.Services.AddAuthorization();

var app = builder.Build();

app.UseHttpsRedirection();

// Specify the path to the frontend folder on default
var frontendPath = Path.GetFullPath(Path.Combine(builder.Environment.ContentRootPath, "../frontend"));
var fileProvider = new PhysicalFileProvider(frontendPath);

// Making index.html the default home page
app.UseDefaultFiles(new DefaultFilesOptions
{
    FileProvider = fileProvider
});

// Allow the browser to load all files (HTML, CSS, JS, images) from the frontend folder
app.UseStaticFiles(new StaticFileOptions
{
    FileProvider = fileProvider
});

// Turn on to using authentication and authorization middleware
app.UseAuthentication();
app.UseAuthorization();

// --- API FOR AUTHENTICATION AND REGISTRATION ---

// User login
app.MapPost("/api/login", async (LoginRequest request, AppDbContext db, HttpContext httpContext) =>
{
    var user = await db.Users.FirstOrDefaultAsync(u => u.Username == request.Username);

    if (user == null || !user.IsActive || !BCrypt.Net.BCrypt.Verify(request.Password, user.PasswordHash))
    {
        return Results.Unauthorized();
    }

    var claims = new List<Claim>
    {
        new Claim(ClaimTypes.NameIdentifier, user.UserId.ToString()),
        new Claim(ClaimTypes.Name, user.Username),
        new Claim(ClaimTypes.GivenName, user.Name),
        new Claim(ClaimTypes.Email, user.Email),
        new Claim(ClaimTypes.Role, user.RoleId.ToString())
    };

    var claimsIdentity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);

    await httpContext.SignInAsync(
        CookieAuthenticationDefaults.AuthenticationScheme,
        new ClaimsPrincipal(claimsIdentity));

    return Results.Ok(new
    {
        username = user.Username,
        name = user.Name,
        roleId = user.RoleId
    });
});

// Register a new user
app.MapPost("/api/register", async (RegisterRequest request, AppDbContext db) =>
{
    if (await db.Users.AnyAsync(u => u.Username == request.Username))
    {
        return Results.BadRequest(new { message = "Username is already taken!" });
    }

    var newUser = new User
    {
        Name = request.Name,
        Email = request.Email,
        Username = request.Username,
        PasswordHash = BCrypt.Net.BCrypt.HashPassword(request.Password),
        RoleId = 1, // enter needed role id for new users
        IsActive = true
    };

    db.Users.Add(newUser);
    await db.SaveChangesAsync();

    return Results.Ok(new { message = "User registered successfully!" });
});

// Check the current logged-in user
app.MapGet("/api/me", (HttpContext httpContext) =>
{
    if (httpContext.User.Identity?.IsAuthenticated == true)
    {
        return Results.Ok(new
        {
            username = httpContext.User.Identity.Name,
            name = httpContext.User.FindFirst(ClaimTypes.GivenName)?.Value,
            roleId = httpContext.User.FindFirst(ClaimTypes.Role)?.Value
        });
    }
    return Results.Unauthorized();
});

// Logout
app.MapPost("/api/logout", async (HttpContext httpContext) =>
{
    await httpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
    return Results.Ok(new { message = "You have been logged out." });
});

app.Run();

// Data models for incoming requests
record LoginRequest(string Username, string Password);
record RegisterRequest(string Name, string Email, string Username, string Password);