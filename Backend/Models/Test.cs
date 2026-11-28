using System;
using System.Collections.Generic;

namespace Backend.Models;

public partial class Test
{
    public long TestingId { get; set; }

    public string TestingName { get; set; } = null!;

    public long ProjectId { get; set; }

    public long? TesterId { get; set; }

    public string? Description { get; set; }

    public DateTime CreatedAt { get; set; }

    public DateTime UpdatedAt { get; set; }

    public string? Status { get; set; }

    public virtual Project Project { get; set; } = null!;

    public virtual ICollection<Solution> Solutions { get; set; } = new List<Solution>();

    public virtual User? Tester { get; set; }
}
