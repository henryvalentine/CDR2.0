using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SpaServices.ReactDevelopmentServer;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Serilog;
using Microsoft.EntityFrameworkCore.SqlServer;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using CDR.Infrastructure;
using Microsoft.AspNetCore.SpaServices.Webpack;
//using Entities.Models;
using Services.Interfaces;
//using Services.CDRServices;
using Services.Utils;
using AutoMapper;
using Microsoft.AspNetCore.Identity;

namespace CDR
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            //services.AddDbContext<CDRContext>(options => options.UseSqlServer(Configuration.GetConnectionString("dbConn")));
            //services.AddDbContext<CDR.Models.CDRContext>(options => options.UseSqlServer(Configuration.GetConnectionString("identity"))); 
            // services.AddIdentity<CDR.Areas.Identity.Data.CDRUser, IdentityRole>().AddEntityFrameworkStores<CDR.Models.CDRContext>();
            // .AddDefaultTokenProviders();

            //Application's services here....
            //services.AddTransient<IPatientService, PatientService>();
            //services.AddTransient<IArtVisitService, ArtVisitService>();
            //services.AddTransient<ILabResultService, LabResultService>();
            //services.AddTransient<ISiteDataTrackingService, SiteDataTrackingService>();
            //services.AddTransient<ISiteService, SiteService>();
            //services.AddTransient<IStatsService, StatsService>();
            //services.AddTransient<IUserService, UserService>();
            //services.AddTransient<IArtBaselineService, ArtBaselineService>();
            //services.AddTransient<IRegimenService, RegimenService>();

            // Auto Mapper Configurations
            //var mappingConfig = new MapperConfiguration(mc =>
            //{
            //    mc.AddProfile(new MappingProfile());
            //});

            //IMapper mapper = mappingConfig.CreateMapper();
            //services.AddSingleton(mapper);

            // services.AddAutoMapper(typeof(Startup).Assembly);

            Configuration.GetSection("AppSettings").Bind(AppSettings.Default);

            services.AddLogging(loggingBuilder =>
                loggingBuilder
                    .AddSerilog(dispose: true)
                    .AddAzureWebAppDiagnostics()
                );
            services.AddMvc().SetCompatibilityVersion(CompatibilityVersion.Version_2_2).AddSessionStateTempDataProvider();
            services.AddNodeServices();
            services.AddSpaPrerenderer();
            services.AddSession();

        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            app.UseMiddleware<ExceptionMiddleware>();

            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
                app.UseWebpackDevMiddleware(new WebpackDevMiddlewareOptions
                {
                    HotModuleReplacement = true
                });
            }
            else
            {
                app.UseExceptionHandler("/Main/Error");
            }

            app.UseSession();
            app.UseStaticFiles();
            app.UseAuthentication();
            app.UseMvc(routes =>
            {
                routes.MapRoute(
                    name: "default",
                    template: "{controller=Main}/{action=Index}/{id?}");

                routes.MapSpaFallbackRoute(
                    name: "spa-fallback",
                    defaults: new { controller = "Main", action = "Index" });
            });
        }
    }
}
