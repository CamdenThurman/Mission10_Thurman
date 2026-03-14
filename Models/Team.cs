namespace Mission10_Thurman.Models
{
    public class Team
    {
        public int TeamID { get; set; }

        public string TeamName { get; set; }

        public List<Bowler> Bowlers { get; set; }
    }
}
