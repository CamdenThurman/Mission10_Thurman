using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Mission10_Thurman.Data;

namespace Mission10_Thurman.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class BowlersController : ControllerBase
    {
        private BowlingContext _context;

        public BowlersController(BowlingContext context)
        {
            _context = context;
        }

        [HttpGet]
        public IActionResult Get()
        {
            var bowlers = _context.Bowlers
                .Include(b => b.Team)
                .Where(b => b.Team.TeamName == "Marlins" || b.Team.TeamName == "Sharks")
                .Select(b => new
                {
                    FirstName = b.BowlerFirstName,
                    Middle = b.BowlerMiddleInit,
                    LastName = b.BowlerLastName,
                    Team = b.Team.TeamName,
                    Address = b.BowlerAddress,
                    City = b.BowlerCity,
                    State = b.BowlerState,
                    Zip = b.BowlerZip,
                    Phone = b.BowlerPhoneNumber
                })
                .ToList();

            return Ok(bowlers);
        }
    }
}
