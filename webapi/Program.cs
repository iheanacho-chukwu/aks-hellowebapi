using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Hosting;

var builder = WebApplication.CreateBuilder(args);

// Configure Kestrel to listen on all network interfaces on port 80
builder.WebHost.ConfigureKestrel(options =>
{
    options.ListenAnyIP(80); // Listen on 0.0.0.0:80
});

var app = builder.Build();

// A single endpoint that returns a basic message
app.MapGet("/", () => "Hello from this side of life!");

app.Run();
