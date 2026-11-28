using System;
using System.Collections.Generic;

namespace Backend.Models;

public partial class Organization
{
    public long OrganizationId { get; set; }

    public string OrganizationName { get; set; } = null!;

    public string? Email { get; set; }

    public string? RepresenterName { get; set; }

    public long? AdminId { get; set; }

    public virtual User? Admin { get; set; }

    public virtual ICollection<Project> Projects { get; set; } = new List<Project>();
}
