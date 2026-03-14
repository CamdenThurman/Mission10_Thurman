using Microsoft.EntityFrameworkCore;
using Mission10_Thurman.Models;

namespace Mission10_Thurman.Data
{
    public class BowlingContext : DbContext
    {
        public BowlingContext(DbContextOptions<BowlingContext> options)
            : base(options)
        {
        }

        public DbSet<Bowler> Bowlers { get; set; }
        public DbSet<Team> Teams { get; set; }
    }
}
