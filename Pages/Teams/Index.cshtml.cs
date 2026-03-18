using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using Mission10_Thurman.Data;
using Mission10_Thurman.Models;

namespace Mission10_Thurman.Pages.Teams
{
    public class IndexModel : PageModel
    {
        private readonly BowlingContext _context;

        public IndexModel(BowlingContext context)
        {
            _context = context;
        }

        public IList<Team> Teams { get; set; } = new List<Team>();

        public async Task OnGetAsync()
        {
            Teams = await _context.Teams
                .AsNoTracking()
                .ToListAsync();
        }
    }
}