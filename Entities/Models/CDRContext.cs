using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace Entities.Models
{
    public partial class CDRContext : DbContext
    {
        public CDRContext()
        {
        }

        public CDRContext(DbContextOptions<CDRContext> options)
            : base(options)
        {
        }

        public virtual DbSet<AspNetRoleClaims> AspNetRoleClaims { get; set; }
        public virtual DbSet<AspNetRoles> AspNetRoles { get; set; }
        public virtual DbSet<AspNetUserClaims> AspNetUserClaims { get; set; }
        public virtual DbSet<AspNetUserLogins> AspNetUserLogins { get; set; }
        public virtual DbSet<AspNetUserRoles> AspNetUserRoles { get; set; }
        public virtual DbSet<AspNetUserTokens> AspNetUserTokens { get; set; }
        public virtual DbSet<AspNetUsers> AspNetUsers { get; set; }
        public virtual DbSet<FingerPrint> FingerPrint { get; set; }
        public virtual DbSet<HivEncounter> HivEncounter { get; set; }
        public virtual DbSet<LaboratoryReport> LaboratoryReport { get; set; }
        public virtual DbSet<PatientDemography> PatientDemography { get; set; }
        public virtual DbSet<PatientRegimen> PatientRegimen { get; set; }
        public virtual DbSet<Regimen> Regimen { get; set; }
        public virtual DbSet<Site> Site { get; set; }
        public virtual DbSet<SiteTxTarget> SiteTxTarget { get; set; }
        public virtual DbSet<State> State { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. See http://go.microsoft.com/fwlink/?LinkId=723263 for guidance on storing connection strings.
                optionsBuilder.UseSqlServer("Server=jackv;Database=CDR;Trusted_Connection=True;");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.HasAnnotation("ProductVersion", "2.2.6-servicing-10079");

            modelBuilder.Entity<AspNetRoleClaims>(entity =>
            {
                entity.HasIndex(e => e.RoleId);

                entity.Property(e => e.RoleId).IsRequired();

                entity.HasOne(d => d.Role)
                    .WithMany(p => p.AspNetRoleClaims)
                    .HasForeignKey(d => d.RoleId);
            });

            modelBuilder.Entity<AspNetRoles>(entity =>
            {
                entity.HasIndex(e => e.NormalizedName)
                    .HasName("RoleNameIndex")
                    .IsUnique()
                    .HasFilter("([NormalizedName] IS NOT NULL)");

                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.Name).HasMaxLength(256);

                entity.Property(e => e.NormalizedName).HasMaxLength(256);
            });

            modelBuilder.Entity<AspNetUserClaims>(entity =>
            {
                entity.HasIndex(e => e.UserId);

                entity.Property(e => e.UserId).IsRequired();

                entity.HasOne(d => d.User)
                    .WithMany(p => p.AspNetUserClaims)
                    .HasForeignKey(d => d.UserId);
            });

            modelBuilder.Entity<AspNetUserLogins>(entity =>
            {
                entity.HasKey(e => new { e.LoginProvider, e.ProviderKey });

                entity.HasIndex(e => e.UserId);

                entity.Property(e => e.LoginProvider).HasMaxLength(128);

                entity.Property(e => e.ProviderKey).HasMaxLength(128);

                entity.Property(e => e.UserId).IsRequired();

                entity.HasOne(d => d.User)
                    .WithMany(p => p.AspNetUserLogins)
                    .HasForeignKey(d => d.UserId);
            });

            modelBuilder.Entity<AspNetUserRoles>(entity =>
            {
                entity.HasKey(e => new { e.UserId, e.RoleId });

                entity.HasIndex(e => e.RoleId);

                entity.HasOne(d => d.Role)
                    .WithMany(p => p.AspNetUserRoles)
                    .HasForeignKey(d => d.RoleId);

                entity.HasOne(d => d.User)
                    .WithMany(p => p.AspNetUserRoles)
                    .HasForeignKey(d => d.UserId);
            });

            modelBuilder.Entity<AspNetUserTokens>(entity =>
            {
                entity.HasKey(e => new { e.UserId, e.LoginProvider, e.Name });

                entity.Property(e => e.LoginProvider).HasMaxLength(128);

                entity.Property(e => e.Name).HasMaxLength(128);

                entity.HasOne(d => d.User)
                    .WithMany(p => p.AspNetUserTokens)
                    .HasForeignKey(d => d.UserId);
            });

            modelBuilder.Entity<AspNetUsers>(entity =>
            {
                entity.HasIndex(e => e.NormalizedEmail)
                    .HasName("EmailIndex");

                entity.HasIndex(e => e.NormalizedUserName)
                    .HasName("UserNameIndex")
                    .IsUnique()
                    .HasFilter("([NormalizedUserName] IS NOT NULL)");

                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.Email).HasMaxLength(256);

                entity.Property(e => e.NormalizedEmail).HasMaxLength(256);

                entity.Property(e => e.NormalizedUserName).HasMaxLength(256);

                entity.Property(e => e.UserName).HasMaxLength(256);
            });

            modelBuilder.Entity<FingerPrint>(entity =>
            {
                entity.Property(e => e.FingerPosition).IsRequired();

                entity.Property(e => e.Source).HasMaxLength(50);

                entity.Property(e => e.Template).IsRequired();

                entity.HasOne(d => d.Patient)
                    .WithMany(p => p.FingerPrint)
                    .HasForeignKey(d => d.PatientId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_FingerPrint_PatientDemography");
            });

            modelBuilder.Entity<HivEncounter>(entity =>
            {
                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.ArvdrugRegimenCode)
                    .HasColumnName("ARVDrugRegimenCode")
                    .HasMaxLength(20);

                entity.Property(e => e.ArvdrugRegimenDesc)
                    .HasColumnName("ARVDrugRegimenDesc")
                    .HasMaxLength(50);

                entity.Property(e => e.BloodPressure).HasMaxLength(50);

                entity.Property(e => e.FunctionalStatus).HasMaxLength(20);

                entity.Property(e => e.NextAppointmentDate).HasColumnType("date");

                entity.Property(e => e.PatientId).ValueGeneratedOnAdd();

                entity.Property(e => e.VisitDate).HasColumnType("date");

                entity.Property(e => e.VisitId).HasColumnName("VisitID");

                entity.Property(e => e.WhoclinicalStage)
                    .HasColumnName("WHOClinicalStage")
                    .HasMaxLength(5);

                entity.HasOne(d => d.Patient)
                    .WithMany(p => p.HivEncounter)
                    .HasForeignKey(d => d.PatientId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_HivEncounter_PatientDemography");
            });

            modelBuilder.Entity<LaboratoryReport>(entity =>
            {
                entity.Property(e => e.ArtstatusCode)
                    .HasColumnName("ARTStatusCode")
                    .HasMaxLength(20);

                entity.Property(e => e.CollectionDate).HasColumnType("date");

                entity.Property(e => e.LabTestCode).HasMaxLength(20);

                entity.Property(e => e.LabTestDesc).HasMaxLength(150);

                entity.Property(e => e.OrderedTestDate).HasColumnType("date");

                entity.Property(e => e.ResultedTestDate).HasColumnType("date");

                entity.Property(e => e.VisitDate).HasColumnType("date");

                entity.Property(e => e.VisitId).HasColumnName("VisitID");

                entity.HasOne(d => d.Patient)
                    .WithMany(p => p.LaboratoryReport)
                    .HasForeignKey(d => d.PatientId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_LaboratoryReport_PatientDemography");
            });

            modelBuilder.Entity<PatientDemography>(entity =>
            {
                entity.Property(e => e.AddressTypeCode).HasMaxLength(50);

                entity.Property(e => e.ArtstartDate)
                    .HasColumnName("ARTStartDate")
                    .HasColumnType("date");

                entity.Property(e => e.ConditionCode).HasMaxLength(50);

                entity.Property(e => e.CountryCode).HasMaxLength(50);

                entity.Property(e => e.DateOfFirstReport).HasColumnType("date");

                entity.Property(e => e.DateOfLastReport).HasColumnType("date");

                entity.Property(e => e.DiagnosisDate).HasColumnType("date");

                entity.Property(e => e.EnrolledInHivcareDate)
                    .HasColumnName("EnrolledInHIVCareDate")
                    .HasColumnType("date");

                entity.Property(e => e.EnrolleeCode).HasMaxLength(50);

                entity.Property(e => e.FacilityId)
                    .IsRequired()
                    .HasColumnName("FacilityID")
                    .HasMaxLength(150);

                entity.Property(e => e.FacilityName)
                    .IsRequired()
                    .HasMaxLength(250);

                entity.Property(e => e.FacilityTypeCode)
                    .IsRequired()
                    .HasMaxLength(10);

                entity.Property(e => e.FirstConfirmedHivtestDate)
                    .HasColumnName("FirstConfirmedHIVTestDate")
                    .HasColumnType("date");

                entity.Property(e => e.HospitalNumber).HasMaxLength(50);

                entity.Property(e => e.OtherIdnumber)
                    .HasColumnName("OtherIDNumber")
                    .HasMaxLength(150);

                entity.Property(e => e.OtherIdtypeCode)
                    .HasColumnName("OtherIDTypeCode")
                    .HasMaxLength(50);

                entity.Property(e => e.PatientDateOfBirth).HasColumnType("date");

                entity.Property(e => e.PatientIdentifier)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.PatientSexCode).HasMaxLength(5);

                entity.Property(e => e.ProgramAreaCode).HasMaxLength(50);

                entity.Property(e => e.StateCode).HasMaxLength(50);

                entity.Property(e => e.TransferredOutStatus).HasMaxLength(50);

                entity.HasOne(d => d.Site)
                    .WithMany(p => p.PatientDemography)
                    .HasForeignKey(d => d.SiteId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_PatientDemography_Site");
            });

            modelBuilder.Entity<PatientRegimen>(entity =>
            {
                entity.Property(e => e.DateRegimenEnded).HasMaxLength(10);

                entity.Property(e => e.DateRegimenStarted).HasColumnType("date");

                entity.Property(e => e.PrescribedRegimenCode).HasMaxLength(20);

                entity.Property(e => e.PrescribedRegimenDesc).HasMaxLength(150);

                entity.Property(e => e.PrescribedRegimenDispensedDate).HasColumnType("date");

                entity.Property(e => e.PrescribedRegimenInitialIndicator).HasMaxLength(20);

                entity.Property(e => e.PrescribedRegimenLineCode).HasMaxLength(50);

                entity.Property(e => e.PrescribedRegimenTypeCode).HasMaxLength(50);

                entity.Property(e => e.SubstitutionIndicator).HasMaxLength(20);

                entity.Property(e => e.SwitchIndicator).HasMaxLength(20);

                entity.Property(e => e.VisitDate).HasColumnType("date");

                entity.Property(e => e.VisitId).HasColumnName("VisitID");

                entity.HasOne(d => d.Patient)
                    .WithMany(p => p.PatientRegimen)
                    .HasForeignKey(d => d.PatientId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_PatientRegimen_PatientDemography");
            });

            modelBuilder.Entity<Regimen>(entity =>
            {
                entity.Property(e => e.Code)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.Combination)
                    .IsRequired()
                    .HasMaxLength(250);

                entity.Property(e => e.Line)
                    .IsRequired()
                    .HasMaxLength(50);
            });

            modelBuilder.Entity<Site>(entity =>
            {
                entity.Property(e => e.Lga)
                    .HasColumnName("LGA")
                    .HasMaxLength(50);

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.SiteId)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.StateCode)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.HasOne(d => d.State)
                    .WithMany(p => p.Site)
                    .HasForeignKey(d => d.StateId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Site_State");
            });

            modelBuilder.Entity<SiteTxTarget>(entity =>
            {
                entity.HasOne(d => d.Site)
                    .WithMany(p => p.SiteTxTarget)
                    .HasForeignKey(d => d.SiteId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_SiteTxTarget_Site");
            });

            modelBuilder.Entity<State>(entity =>
            {
                entity.Property(e => e.Code)
                    .IsRequired()
                    .HasMaxLength(20);

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasMaxLength(100);
            });
        }
    }
}
