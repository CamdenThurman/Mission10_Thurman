using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Mission10_Thurman.Data;

namespace Mission10_Thurman.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class HealthController : ControllerBase
    {
        private readonly BowlingContext _context;

        public HealthController(BowlingContext context)
        {
            _context = context ?? throw new ArgumentNullException(nameof(context));
        }

        [HttpGet]
        public async Task<IActionResult> Get()
        {
            try
            {
                var canConnect = await _context.Database.CanConnectAsync();
                if (canConnect)
                {
                    return Ok(new { databaseConnected = true });
                }

                return StatusCode(503, new { databaseConnected = false, message = "Cannot connect to database." });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { databaseConnected = false, error = ex.Message });
            }
        }
    }
}