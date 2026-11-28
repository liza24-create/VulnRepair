using System;
using System.Collections.Generic;

namespace Backend.Models;

public partial class Project
{
    public long ProjectId { get; set; }

    public string ProjectName { get; set; } = null!;

    public long OrganizationId { get; set; }

    public long? ManagerId { get; set; }

    public DateTime CreatedAt { get; set; }

    public DateTime UpdatedAt { get; set; }

    public string? Status { get; set; }

    public virtual User? Manager { get; set; }

    public virtual Organization Organization { get; set; } = null!;

    public virtual ICollection<Test> Tests { get; set; } = new List<Test>();
}
