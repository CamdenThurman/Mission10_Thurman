using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using Mission10_Thurman.Data;
using Mission10_Thurman.Models;

namespace Mission10_Thurman.Pages.Bowlers
{
    public class IndexModel : PageModel
    {
        private readonly BowlingContext _context;

        public IndexModel(BowlingContext context)
        {
            _context = context;
        }

        public IList<Bowler> Bowlers { get; set; } = new List<Bowler>();

        public async Task OnGetAsync()
        {
            Bowlers = await _context.Bowlers
                .Include(b => b.Team)
                .AsNoTracking()
                .Where(b => b.Team.TeamName == "Marlins" || b.Team.TeamName == "Sharks")
                .ToListAsync();
        }
    }
}