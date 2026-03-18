using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using Mission10_Thurman.Data;
using Mission10_Thurman.Models;

namespace Mission10_Thurman.Pages.Teams
{
    public class DetailsModel : PageModel
    {
        private readonly BowlingContext _context;

        public DetailsModel(BowlingContext context)
        {
            _context = context;
        }

        public Team? Team { get; set; }

        public IList<Bowler> Bowlers { get; set; } = new List<Bowler>();

        public async Task<IActionResult> OnGetAsync(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            Team = await _context.Teams
                .AsNoTracking()
                .FirstOrDefaultAsync(t => t.TeamID == id);

            if (Team == null)
            {
                return NotFound();
            }

            Bowlers = await _context.Bowlers
                .AsNoTracking()
                .Where(b => b.TeamID == id)
                .ToListAsync();

            return Page();
        }
    }
}