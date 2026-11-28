using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace Backend.Models;

public partial class AppDbContext : DbContext
{
    public AppDbContext()
    {
    }

    public AppDbContext(DbContextOptions<AppDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Organization> Organizations { get; set; }

    public virtual DbSet<Project> Projects { get; set; }

    public virtual DbSet<Solution> Solutions { get; set; }

    public virtual DbSet<Test> Tests { get; set; }

    public virtual DbSet<User> Users { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseNpgsql("Host=localhost;Port=5432;Database=vr_db;Username=postgres;Password=pgsql24");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Organization>(entity =>
        {
            entity.HasKey(e => e.OrganizationId).HasName("organizations_pkey");

            entity.ToTable("organizations");

            entity.Property(e => e.OrganizationId)
                .UseIdentityAlwaysColumn()
                .HasColumnName("organization_id");
            entity.Property(e => e.AdminId).HasColumnName("admin_id");
            entity.Property(e => e.Email)
                .HasMaxLength(255)
                .HasColumnName("email");
            entity.Property(e => e.OrganizationName)
                .HasMaxLength(255)
                .HasColumnName("organization_name");
            entity.Property(e => e.RepresenterName)
                .HasMaxLength(255)
                .HasColumnName("representer_name");

            entity.HasOne(d => d.Admin).WithMany(p => p.Organizations)
                .HasForeignKey(d => d.AdminId)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_organizations_admin");
        });

        modelBuilder.Entity<Project>(entity =>
        {
            entity.HasKey(e => e.ProjectId).HasName("projects_pkey");

            entity.ToTable("projects");

            entity.Property(e => e.ProjectId)
                .UseIdentityAlwaysColumn()
                .HasColumnName("project_id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("created_at");
            entity.Property(e => e.ManagerId).HasColumnName("manager_id");
            entity.Property(e => e.OrganizationId).HasColumnName("organization_id");
            entity.Property(e => e.ProjectName)
                .HasMaxLength(255)
                .HasColumnName("project_name");
            entity.Property(e => e.Status)
                .HasMaxLength(100)
                .HasColumnName("status");
            entity.Property(e => e.UpdatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("updated_at");

            entity.HasOne(d => d.Manager).WithMany(p => p.Projects)
                .HasForeignKey(d => d.ManagerId)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_projects_manager");

            entity.HasOne(d => d.Organization).WithMany(p => p.Projects)
                .HasForeignKey(d => d.OrganizationId)
                .HasConstraintName("fk_projects_organization");
        });

        modelBuilder.Entity<Solution>(entity =>
        {
            entity.HasKey(e => e.SolutionId).HasName("solutions_pkey");

            entity.ToTable("solutions");

            entity.Property(e => e.SolutionId)
                .UseIdentityAlwaysColumn()
                .HasColumnName("solution_id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("created_at");
            entity.Property(e => e.DeveloperId).HasColumnName("developer_id");
            entity.Property(e => e.Solution1).HasColumnName("solution");
            entity.Property(e => e.SolutionName)
                .HasMaxLength(255)
                .HasColumnName("solution_name");
            entity.Property(e => e.Status)
                .HasMaxLength(100)
                .HasColumnName("status");
            entity.Property(e => e.TestingId).HasColumnName("testing_id");
            entity.Property(e => e.UpdatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("updated_at");

            entity.HasOne(d => d.Developer).WithMany(p => p.Solutions)
                .HasForeignKey(d => d.DeveloperId)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_solutions_developer");

            entity.HasOne(d => d.Testing).WithMany(p => p.Solutions)
                .HasForeignKey(d => d.TestingId)
                .OnDelete(DeleteBehavior.Cascade)
                .HasConstraintName("fk_solutions_testing");
        });

        modelBuilder.Entity<Test>(entity =>
        {
            entity.HasKey(e => e.TestingId).HasName("tests_pkey");

            entity.ToTable("tests");

            entity.Property(e => e.TestingId)
                .UseIdentityAlwaysColumn()
                .HasColumnName("testing_id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("created_at");
            entity.Property(e => e.Description).HasColumnName("description");
            entity.Property(e => e.ProjectId).HasColumnName("project_id");
            entity.Property(e => e.Status)
                .HasMaxLength(100)
                .HasColumnName("status");
            entity.Property(e => e.TesterId).HasColumnName("tester_id");
            entity.Property(e => e.TestingName)
                .HasMaxLength(255)
                .HasColumnName("testing_name");
            entity.Property(e => e.UpdatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("updated_at");

            entity.HasOne(d => d.Project).WithMany(p => p.Tests)
                .HasForeignKey(d => d.ProjectId)
                .HasConstraintName("fk_testing_project");

            entity.HasOne(d => d.Tester).WithMany(p => p.Tests)
                .HasForeignKey(d => d.TesterId)
                .OnDelete(DeleteBehavior.Restrict)
                .HasConstraintName("fk_testing_tester");
        });

        modelBuilder.Entity<User>(entity =>
        {
            entity.HasKey(e => e.UserId).HasName("users_pkey");

            entity.ToTable("users");

            entity.HasIndex(e => e.Email, "users_email_key").IsUnique();

            entity.HasIndex(e => e.Username, "users_username_key").IsUnique();

            entity.Property(e => e.UserId)
                .UseIdentityAlwaysColumn()
                .HasColumnName("user_id");
            entity.Property(e => e.BirthDate).HasColumnName("birth_date");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("created_at");
            entity.Property(e => e.Email)
                .HasMaxLength(255)
                .HasColumnName("email");
            entity.Property(e => e.IsActive)
                .HasDefaultValue(true)
                .HasColumnName("is_active");
            entity.Property(e => e.Name)
                .HasMaxLength(255)
                .HasColumnName("name");
            entity.Property(e => e.PasswordHash).HasColumnName("password_hash");
            entity.Property(e => e.PhoneNumber)
                .HasMaxLength(20)
                .HasColumnName("phone_number");
            entity.Property(e => e.RoleId).HasColumnName("role_id");
            entity.Property(e => e.UpdatedAt)
                .HasDefaultValueSql("now()")
                .HasColumnName("updated_at");
            entity.Property(e => e.Username)
                .HasMaxLength(100)
                .HasColumnName("username");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
