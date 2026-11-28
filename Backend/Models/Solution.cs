using System;
using System.Collections.Generic;

namespace Backend.Models;

public partial class Solution
{
    public long SolutionId { get; set; }

    public string SolutionName { get; set; } = null!;

    public long? TestingId { get; set; }

    public long? DeveloperId { get; set; }

    public string? Solution1 { get; set; }

    public DateTime CreatedAt { get; set; }

    public DateTime UpdatedAt { get; set; }

    public string? Status { get; set; }

    public virtual User? Developer { get; set; }

    public virtual Test? Testing { get; set; }
}
